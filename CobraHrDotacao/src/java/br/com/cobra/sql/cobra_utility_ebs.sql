create or replace 
PACKAGE COBRA_UTILITY_EBS AUTHID CURRENT_USER IS
/*
#############################################################################
# 
# $Author..: Horacio Vasconcellos, Adriana Ribeiro, Marcus Pessoa, Jorge No, Wagner Souza $
# $Date....: $
# $Revision: $ 
# $HeadURL.: $ 
#
# PARAMETROS UTILIZADOS
# Entrada..:  -
# Saida....: Pagamentos realizados sem vinculação de OC. 
#
# Funcionalidade:  
#
# Alterações e Motivos das Alterações (Data e explicação)                                                   
#
#-Data----------Desenvolvedor-------------- Testador ----------------------- Descrição---------------------             
# 
# 
#############################################################################
*/
/*
#############################################################################
#
# Procedures/Functions Oracle Inventory
#
#############################################################################
*/
 PROCEDURE  setPartNumbers     (errbuf             OUT VARCHAR2,
                                retcode            OUT VARCHAR2, 
                                p_manufacturer_id  IN APPS.MTL_MFG_PART_NUMBERS.manufacturer_id %TYPE, 
                                p_nome_do_arquivo  IN VARCHAR2 DEFAULT 'CARGAPARTNUMBER.xls');
/*
#############################################################################
#
# Procedures/Functions Oracle General Leadger
#
#############################################################################
*/
FUNCTION  getCodeCombination (P_SEGMENT1 IN APPS.GL_CODE_COMBINATIONS.SEGMENT1%TYPE,P_SEGMENT2 IN APPS.GL_CODE_COMBINATIONS.SEGMENT2%TYPE,P_SEGMENT3 IN APPS.GL_CODE_COMBINATIONS.SEGMENT3%TYPE,P_SEGMENT4 IN APPS.GL_CODE_COMBINATIONS.SEGMENT4%TYPE ) RETURN NUMBER;
/*
#############################################################################
#
# Procedures/Functions Oracle Receivables
#
#############################################################################
*/
 FUNCTION   getValorImposto    (p_customer_trx_id    IN APPS.RA_CUSTOMER_TRX_ALL.customer_trx_id%TYPE, p_imposto IN VARCHAR2) RETURN NUMBER;
 FUNCTION   getCliente         (p_customer_id         IN APPS.HZ_CUST_ACCOUNTS.cust_account_id %TYPE) RETURN VARCHAR2;
 PROCEDURE  setRecebimentos    (errbuf           OUT VARCHAR2,
                                retcode          OUT VARCHAR2, 
                                p_customer_id     IN APPS.HZ_CUST_ACCOUNTS.cust_account_id %TYPE, 
                                p_nome_do_arquivo IN VARCHAR2 DEFAULT 'ContasaReceber.xls');

/*
#############################################################################
#
# Procedures/Functions Oracle Order Management
#
#############################################################################
*/ 
 FUNCTION getOrderNumber     (p_numero_da_nff       IN APPS.RA_CUSTOMER_TRX_ALL.TRX_NUMBER%TYPE, p_organization_id    IN APPS.MTL_PARAMETERS.ORGANIZATION_ID%TYPE) RETURN VARCHAR2;
 FUNCTION putCloseSalesOrder (p_numero_da_ordem     IN APPS.OE_ORDER_HEADERS_ALL.ORDER_NUMBER %TYPE,p_numero_da_linha IN APPS.OE_ORDER_LINES_ALL.line_number%TYPE ) RETURN BOOLEAN;
/*
#############################################################################
#
# Procedures/Functions Oracle Purchasing
#
#############################################################################
*/  
 FUNCTION putCloseRequisition   (p_numero_requisicao   IN APPS.PO_REQUISITION_HEADERS_ALL.SEGMENT1 %TYPE) RETURN BOOLEAN;
 FUNCTION geteBusinessPoActions (p_object_id           IN number,  p_object_type_code IN VARCHAR2,  p_action_code in VARCHAR2 DEFAULT 'ANY', p_direction in VARCHAR2 DEFAULT 'NORMAL'/*MAX,MIN*/) RETURN cobratabTyppoActions;
 FUNCTION setFuncionarioVendors (p_person_id           IN APPS.PER_ALL_PEOPLE_F.person_id%TYPE) RETURN NUMBER;
/*
#############################################################################
#
# Procedures/Functions Oracle Recebimento Integrado
#
#############################################################################
*/ 
 FUNCTION getRecLookupValue  (p_lookupType          IN APPS.REC_LOOKUP_CODES.LOOKUP_TYPE%TYPE     ,p_lookupCode IN APPS.REC_LOOKUP_CODES.LOOKUP_CODE%TYPE, p_colunas    IN VARCHAR2 DEFAULT 'LOOKUP_CODE,DISPLAYED_FIELD' ) RETURN VARCHAR2;
/*
#############################################################################
#
# Procedures/Functions Oracle Human Resource, Segurança e Folha de Pagamento
#
#############################################################################
*/ 
 FUNCTION getPessoa          (p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) RETURN VARCHAR2;
 FUNCTION getPessoaAtribuicao(p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE,p_colunas    IN VARCHAR2 DEFAULT 'NOME,MATRICULA,EMAIL,ORGANIZACAO,CARGO,POSICAO,GRADE_NAME,LOCAL,JOB_NAME,PAYROLL,STATUS') RETURN VARCHAR2;
 FUNCTION getPessoaLogin     (p_effective_date      IN DATE,p_user_id      IN APPS.FND_USER.USER_ID%TYPE) RETURN VARCHAR2;
 FUNCTION getUserPersonType  (p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) RETURN VARCHAR2;  
 FUNCTION getPessoaSeg       (p_effective_date      IN DATE,p_matricula    IN VARCHAR2) RETURN VARCHAR2;
 FUNCTION getPessoaTelefone  (p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE,p_tipo IN NUMBER DEFAULT 1) RETURN typarrayvarchar;
 FUNCTION geteBusinessHierOrg(p_person_id           IN number) RETURN cobraTabTypHierOrg;
 FUNCTION getQtdadeLotacao   (p_effective_date      IN DATE,p_local        IN VARCHAR2,p_cargo IN VARCHAR2) RETURN NUMBER;
/*
#############################################################################
#
# Procedures/Functions Oracle Foundation
#
#############################################################################
*/ 
 PROCEDURE expiraPassword;
 PROCEDURE InicializaDebub;
 PROCEDURE sincSegurancaHReFolha;
 PROCEDURE putEscrevenoLogConcurrent(p_strBuffer           IN VARCHAR2);
 PROCEDURE putEscrevenoOutConcurrent (p_strBuffer           IN VARCHAR2);
 FUNCTION  isPeriodosFechados (p_periodo             IN VARCHAR2) RETURN BOOLEAN;
 FUNCTION  getLookupValue      (p_lookupType          IN APPS.FND_LOOKUP_VALUES.LOOKUP_TYPE%TYPE    ,p_lookupCode IN APPS.FND_LOOKUP_VALUES.LOOKUP_CODE%TYPE,  p_colunas    IN VARCHAR2 DEFAULT 'LOOKUP_CODE,MEANING') RETURN VARCHAR2;
 FUNCTION  getFlexValue        (p_flex_value_set_id   IN APPS.FND_FLEX_VALUES.FLEX_VALUE_SET_ID%TYPE,p_flex_value IN APPS.FND_FLEX_VALUES.FLEX_VALUE%TYPE  , p_colunas    IN VARCHAR2 DEFAULT 'A.flex_value,B.description' )    RETURN VARCHAR2;
 FUNCTION  getConcParameter    (p_requestid           IN APPS.FND_CONCURRENT_REQUESTS.REQUEST_ID%TYPE) RETURN typarrayvarchar; 
 FUNCTION  iseBusinessLogin    (p_username            IN VARCHAR2,  p_password IN VARCHAR2) RETURN BOOLEAN;
 FUNCTION setUserResponsibility(p_user_name           IN APPS.FND_USER.USER_NAME%TYPE,
                                p_responsibility_name IN APPS.FND_RESPONSIBILITY_VL.RESPONSIBILITY_NAME%TYPE ) RETURN BOOLEAN;
 FUNCTION  getRequesteBusiness (p_application    IN VARCHAR2 default NULL,        p_program     IN VARCHAR2 default NULL,
                                p_description    IN VARCHAR2 default NULL,		    p_start_time  IN VARCHAR2 default NULL,
                                p_sub_request    IN boolean  default FALSE,		    p_argument1   IN VARCHAR2 default CHR(0),
                                p_argument2      IN VARCHAR2 default CHR(0),		  p_argument3   IN VARCHAR2 default CHR(0),
                                p_argument4      IN VARCHAR2 default CHR(0),		  p_argument5   IN VARCHAR2 default CHR(0),
                                p_argument6      IN VARCHAR2 default CHR(0),		  p_argument7   IN VARCHAR2 default CHR(0),
                                p_argument8      IN VARCHAR2 default CHR(0),		  p_argument9   IN VARCHAR2 default CHR(0),
                                p_argument10     IN VARCHAR2 default CHR(0),		  p_argument11  IN VARCHAR2 default CHR(0),
                                p_argument12     IN VARCHAR2 default CHR(0),		  p_argument13  IN VARCHAR2 default CHR(0),
                                p_argument14     IN VARCHAR2 default CHR(0),		  p_argument15  IN VARCHAR2 default CHR(0),
                                p_argument16     IN VARCHAR2 default CHR(0),		  p_argument17  IN VARCHAR2 default CHR(0),
                                p_argument18     IN VARCHAR2 default CHR(0),		  p_argument19  IN VARCHAR2 default CHR(0),
                                p_argument20     IN VARCHAR2 default CHR(0),		  p_argument21  IN VARCHAR2 default CHR(0),
                                p_argument22     IN VARCHAR2 default CHR(0),		  p_argument23  IN VARCHAR2 default CHR(0),
                                p_argument24     IN VARCHAR2 default CHR(0),		  p_argument25  IN VARCHAR2 default CHR(0),
                                p_argument26     IN VARCHAR2 default CHR(0),		  p_argument27  IN VARCHAR2 default CHR(0),
                                p_argument28     IN VARCHAR2 default CHR(0),		  p_argument29  IN VARCHAR2 default CHR(0),
                                p_argument30     IN VARCHAR2 default CHR(0),		  p_argument31  IN VARCHAR2 default CHR(0),
                                p_argument32     IN VARCHAR2 default CHR(0),		  p_argument33  IN VARCHAR2 default CHR(0),
                                p_argument34     IN VARCHAR2 default CHR(0),		  p_argument35  IN VARCHAR2 default CHR(0),
                                p_argument36     IN VARCHAR2 default CHR(0),		  p_argument37  IN VARCHAR2 default CHR(0),
                                p_argument38     IN VARCHAR2 default CHR(0),		  p_argument39  IN VARCHAR2 default CHR(0),
                                p_argument40     IN VARCHAR2 default CHR(0),		  p_argument41  IN VARCHAR2 default CHR(0),
                                p_argument42     IN VARCHAR2 default CHR(0),      p_argument43  IN VARCHAR2 default CHR(0),
                                p_argument44     IN VARCHAR2 default CHR(0),		  p_argument45  IN VARCHAR2 default CHR(0),
                                p_argument46     IN VARCHAR2 default CHR(0),		  p_argument47  IN VARCHAR2 default CHR(0),
                                p_argument48     IN VARCHAR2 default CHR(0),      p_argument49  IN VARCHAR2 default CHR(0),
                                p_argument50     IN VARCHAR2 default CHR(0),		  p_argument51  IN VARCHAR2 default CHR(0),
                                p_argument52     IN VARCHAR2 default CHR(0),		  p_argument53  IN VARCHAR2 default CHR(0),
                                p_argument54     IN VARCHAR2 default CHR(0),      p_argument55  IN VARCHAR2 default CHR(0),
                                p_argument56     IN VARCHAR2 default CHR(0),		  p_argument57  IN VARCHAR2 default CHR(0),
                                p_argument58     IN VARCHAR2 default CHR(0),		  p_argument59  IN VARCHAR2 default CHR(0),
                                p_argument60     IN VARCHAR2 default CHR(0),		  p_argument61  IN VARCHAR2 default CHR(0),
                                p_argument62     IN VARCHAR2 default CHR(0),		  p_argument63  IN VARCHAR2 default CHR(0),
                                p_argument64     IN VARCHAR2 default CHR(0),		  p_argument65  IN VARCHAR2 default CHR(0),
                                p_argument66     IN VARCHAR2 default CHR(0),		  p_argument67  IN VARCHAR2 default CHR(0),
                                p_argument68     IN VARCHAR2 default CHR(0),		  p_argument69  IN VARCHAR2 default CHR(0),
                                p_argument70     IN VARCHAR2 default CHR(0),      p_argument71  IN VARCHAR2 default CHR(0),
                                p_argument72     IN VARCHAR2 default CHR(0),		  p_argument73  IN VARCHAR2 default CHR(0),
                                p_argument74     IN VARCHAR2 default CHR(0),		  p_argument75  IN VARCHAR2 default CHR(0),
                                p_argument76     IN VARCHAR2 default CHR(0),		  p_argument77  IN VARCHAR2 default CHR(0),
                                p_argument78     IN VARCHAR2 default CHR(0),		  p_argument79  IN VARCHAR2 default CHR(0),
                                p_argument80     IN VARCHAR2 default CHR(0),		  p_argument81  IN VARCHAR2 default CHR(0),
                                p_argument82     IN VARCHAR2 default CHR(0),		  p_argument83  IN VARCHAR2 default CHR(0),
                                p_argument84     IN VARCHAR2 default CHR(0),		  p_argument85  IN VARCHAR2 default CHR(0),
                                p_argument86     IN VARCHAR2 default CHR(0),		  p_argument87  IN VARCHAR2 default CHR(0),
                                p_argument88     IN VARCHAR2 default CHR(0),		  p_argument89  IN VARCHAR2 default CHR(0),
                                p_argument90     IN VARCHAR2 default CHR(0),		  p_argument91  IN VARCHAR2 default CHR(0),
                                p_argument92     IN VARCHAR2 default CHR(0), 		  p_argument93  IN VARCHAR2 default CHR(0),
                                p_argument94     IN VARCHAR2 default CHR(0),		  p_argument95  IN VARCHAR2 default CHR(0),
                                p_argument96     IN VARCHAR2 default CHR(0),		  p_argument97  IN VARCHAR2 default CHR(0),
                                p_argument98     IN VARCHAR2 default CHR(0),		  p_argument99  IN VARCHAR2 default CHR(0),
                                p_argument100    in varchar2 default chr(0)		  ) RETURN NUMBER;
PROCEDURE setRelatorioBusiness( errbuf          OUT VARCHAR2             ,retcode OUT VARCHAR2                    , p_nmbRelatorio IN NUMBER ,
                                p_parametro1     IN VARCHAR2 DEFAULT NULL,p_parametro2   IN VARCHAR2 DEFAULT NULL ,
                                p_parametro3     IN VARCHAR2 DEFAULT NULL,p_parametro4   IN VARCHAR2 DEFAULT NULL ,
                                p_parametro5     IN VARCHAR2 DEFAULT NULL,p_parametro6   IN VARCHAR2 DEFAULT NULL ,
                                p_parametro7     IN VARCHAR2 DEFAULT NULL,p_parametro8   IN VARCHAR2 DEFAULT NULL ,
                                p_parametro9     IN VARCHAR2 DEFAULT NULL,p_parametro10  IN VARCHAR2 DEFAULT NULL ,
                                p_parametro11    IN VARCHAR2 DEFAULT NULL,p_parametro12  IN VARCHAR2 DEFAULT NULL ,
                                p_parametro13    IN VARCHAR2 DEFAULT NULL,p_tpRelatorio  IN VARCHAR2 DEFAULT 'XML' );
FUNCTION getValidaSegEbsLogin  (p_username IN VARCHAR2,  p_password IN VARCHAR2) RETURN VARCHAR2;
END COBRA_UTILITY_EBS;

create or replace 
PACKAGE BODY COBRA_UTILITY_EBS AS
/*
#############################################################################
# 
# $Author..: Horacio Vasconcellos, Adriana Ribeiro, Marcus Pessoa $
# $Date....: $
# $Revision: $ 
# $HeadURL.: $ 
#
# PARAMETROS UTILIZADOS
# Entrada..: 
# Saida....: 
#
# Funcionalidade:  
# getCodeCombination   : Informado os 4 segmentos, retorna o Code_Combination_id. Cria se este não existir
# getValorImposto      : Dado o Id da Nota,Id da Linha e Imposto retorna o seu valor
# getCliente           : Equalização com a TCA, recebe p_customer_id e retorna o Cliente
# getOrderNumber       : Retorna as Ordens de Venda de uma Nota Fiscal  
# putCloseSalesOrder   : Efetua o fechamento de uma linha da Ordem e/ou Fecha a Ordem
# putCloseRequisition  : Efetua o fechamento de uma requisição de compra/interna
# geteBusinessPoActions: Busca informação das ações de um determinado objeto (Req/PO)
# setFuncionarioVendors: Configura um Funcionário como Fornecedor (Não CORE - Retirando a trigger) 
# getRecLookupValue    : Retorna o valor de uma Lookup do módulo do Recebimento Integrado
# getPessoa            : Retorna o nome e matricula da pessoa (Acesso rápido)
# getPessoaAtribuicao  : Retorna por padrão NOME,MATRICULA,EMAIL,ORGANIZACAO,CARGO,POSICAO,GRADE_NAME,LOCAL,JOB_NAME,PAYROLL,STATUS, mas vc pode selecionar os campos.
# getPessoaLogin       : Retorna o nome do colaborador de um determinado Login
# getUserPersonType    : Retorna o Tipo de Pessoa
# getPessoaSeg         : Retorna o email do colaborador e Login de Rede
# getPessoaTelefone    : Retorna todos os telefones cadastrados de uma determinada pessoa
# geteBusinessHierOrg  : Retorna a Hierarquia de uma Pessoa
# setRecebimentos      : Efetua Recebimentos e Ajustes oriundos de uma planilha Excel.
# 
# 
#
#-Data----------Desenvolvedor-------------- Testador ----------------------- Descrição---------------------             
# 
# 
#############################################################################
*/
/*
#############################################################################
#
# Procedures/Functions Oracle Inventory
#
#############################################################################
*/
PROCEDURE  setPartNumbers     ( errbuf             OUT VARCHAR2,
                                retcode            OUT VARCHAR2, 
                                p_manufacturer_id  IN APPS.MTL_MFG_PART_NUMBERS.manufacturer_id %TYPE, 
                                p_nome_do_arquivo  IN VARCHAR2 DEFAULT 'CARGAPARTNUMBER.xls')
AS
   consNmbUserId                    CONSTANT NUMBER                                        := FND_PROFILE.VALUE('COBRA:USUARIO_INTERFACE');
   consOrgId                        CONSTANT NUMBER                                        := FND_PROFILE.VALUE('ORG_ID');
   consSetOfBook                    CONSTANT NUMBER                                        := FND_PROFILE.VALUE('GL_SET_OF_BKS_ID');
   consDataGL                       CONSTANT DATE                                          := TRUNC(SYSDATE,'DD');
   consCharSim                      CONSTANT CHAR(1)                                       := 'Y';
   consCharFalse                    CONSTANT CHAR(1)                                       := 'F';
   x_exception_msg                  VARCHAR2(4000);
   l_msg_data                       VARCHAR2(240);
   strStatus                        VARCHAR2(1000);
   strReturnStatus                  VARCHAR2(4000);
   strCabecalhoPadrao               VARCHAR2(4000)                                         := 'COMPONENTE^ITEM^DESCRICAO^';
   strRegistro                      VARCHAR2(4000);
   strCaminhoDefault                VARCHAR2(4000)                                         :='/transferencia/interface/';
   strArquivoPadrao                 VARCHAR2(4000);
   nmbContador                      NUMBER                                                 := 0;
   nmbProcessados                   NUMBER                                                 := 0;
   nmbLocalizado                    NUMBER                                                 := 0;
   nmbOrganizationId                MTL_PARAMETERS.ORGANIZATION_ID%TYPE;
   bolCabecalho                     BOOLEAN                                                := FALSE;
   strRowId                         VARCHAR2(030);
   nmbInventortyItemId              MTL_SYSTEM_ITEMS.INVENTORY_ITEM_ID    %TYPE;  
   strPartNumber                    VARCHAR2(4000);
   strCodigoCobra                   VARCHAR2(4000);
   strDescricao                     VARCHAR2(4000);   
   TYPE regLinha IS RECORD        ( INVENTORY_ITEM_ID                      NUMBER,
                                    CODIGO_COBRA                           VARCHAR2(100),
                                    COMPONENTE                             VARCHAR2(100),
                                    DESCRICAO                              VARCHAR2(4000)
                                    );
  TYPE TabTypRegLinha               IS TABLE OF regLinha;
  registroBaixa                     regLinha;
  tabtypPlanilha                    TabTypRegLinha  := TabTypRegLinha();   
BEGIN
  FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
  FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
  FND_FILE.put_line( FND_FILE.LOG,'*                Iniciando o processo de Carga do PartNumber de Fornecedor                     *');
  FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
  FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
  BEGIN
    SELECT ORGANIZATION_ID  INTO nmbOrganizationId
      FROM MTL_PARAMETERS 
     WHERE ORGANIZATION_ID = MASTER_ORGANIZATION_ID;
  EXCEPTION
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001,'Falha na identificação da Organização Mestre.');
         RETCODE := 2;
  END;
  BEGIN
    strArquivoPadrao := COBRA_UTILITY.EXCELTOSTRING(strCaminhoDefault || p_nome_do_arquivo);
    FND_FILE.put_line( FND_FILE.LOG,'* ' || strCaminhoDefault || p_nome_do_arquivo);
  EXCEPTION
    WHEN OTHERS THEN
        FND_FILE.put_line( FND_FILE.LOG,'Arquivo: ' || strCaminhoDefault || p_nome_do_arquivo || ' não foi localizado no local definido.');
        RETCODE := 2;
        RAISE_APPLICATION_ERROR (-20002,'Arquivo: ' || strCaminhoDefault || p_nome_do_arquivo || ' não foi localizado no local definido.');
    RETURN;
  END;
  nmbContador := 0;
  FOR reg IN (SELECT column_value FROM TABLE(COBRA_UTILITY.getArquivoCollection('INTERFACE',strArquivoPadrao))) LOOP
    IF nmbContador = 0 THEN
         IF UPPER(strCabecalhoPadrao) <> UPPER(reg.column_value) THEN
             FND_FILE.put_line( FND_FILE.LOG,'* Padrão: ' || UPPER(strCabecalhoPadrao));
             FND_FILE.put_line( FND_FILE.LOG,'* Lido  : ' || UPPER(reg.column_value));
             bolCabecalho := TRUE;
         END IF;
    ELSE
       BEGIN
          strPartNumber            := COBRA_UTILITY.GETPIECE(reg.column_value,'^',1);
          strCodigoCobra           := COBRA_UTILITY.GETPIECE(reg.column_value,'^',2);
          strDescricao             := COBRA_UTILITY.GETPIECE(reg.column_value,'^',3);
          SELECT INVENTORY_ITEM_ID   INTO nmbInventortyItemId
            FROM MTL_SYSTEM_ITEMS
           WHERE UPPER(SEGMENT1 || '-' || SEGMENT2) = UPPER(strCodigoCobra)
             AND ORGANIZATION_ID                    = nmbOrganizationId;
       EXCEPTION
         WHEN OTHERS THEN
              nmbInventortyItemId := -1;
              FND_FILE.put_line( FND_FILE.LOG,'* Item da Planilha ' || TO_CHAR(nmbContador) || ', ' || strPartNumber || ' com Codigo Cobra: ' || strCodigoCobra);
              RETCODE := 1;
       END;
       BEGIN
          nmbLocalizado := 0;
          SELECT COUNT(*)  INTO nmbLocalizado
            FROM MTL_MFG_PART_NUMBERS    
           WHERE  MFG_PART_NUM        = strPartNumber --    MANUFACTURER_ID     = P_MANUFACTURER_ID
                                                      --AND ORGANIZATION_ID     = nmbOrganizationId
                                                      ;
       EXCEPTION
         WHEN OTHERS THEN
             nmbLocalizado := 10;  
       END;
       IF nmbLocalizado > 0 THEN
          nmbInventortyItemId := -1;
       END IF;
       FND_FILE.put_line( FND_FILE.LOG,'* ' ||strPartNumbeR || ' COM ' || nmbInventortyItemId || ' id: ' ||  nmbLocalizado);  
       tabtypPlanilha.extend;
       tabtypPlanilha(tabtypPlanilha.last).INVENTORY_ITEM_ID       := nmbInventortyItemId;
       tabtypPlanilha(tabtypPlanilha.last).CODIGO_COBRA            := strCodigoCobra;
       tabtypPlanilha(tabtypPlanilha.last).COMPONENTE              := strPartNumber;
       tabtypPlanilha(tabtypPlanilha.last).DESCRICAO               := strDescricao;
      END IF;
      nmbContador := nmbContador + 1;
  END LOOP;
  IF bolCabecalho THEN
     FND_FILE.put_line( FND_FILE.LOG,'* Arquivo recebido fora das especificações acordadas: ' || strCabecalhoPadrao);   
     RETCODE := 1;
     RETURN;
  END IF;
  FOR reg IN tabtypPlanilha.FIRST..tabtypPlanilha.LAST LOOP
      IF tabtypPlanilha(reg).inventory_item_id > 0 THEN
         nmbProcessados := nmbProcessados + 1;
         MTL_MFG_PART_NUMBERS_PKG.Insert_Row( X_Rowid                         => strRowId,
                                              X_Manufacturer_Id               => P_MANUFACTURER_ID,
                                              X_Mfg_Part_Num                  => tabtypPlanilha(reg).COMPONENTE,
                                              X_Inventory_Item_Id             => tabtypPlanilha(reg).INVENTORY_ITEM_ID,
                                              X_Last_Update_Date              => consDataGL,
                                              X_Last_Updated_By               => consNmbUserId,
                                              X_Creation_Date                 => consDataGL,
                                              X_Created_By                    => consNmbUserId,
                                              X_Last_Update_Login             => consNmbUserId,
                                              X_Organization_Id               => nmbOrganizationId,
                                              X_Description                   => SUBSTR(tabtypPlanilha(reg).DESCRICAO,1,240),
                                              X_Attribute_Category            => NULL,
                                              X_Attribute1                    => NULL,
                                              X_Attribute2                    => NULL,
                                              X_Attribute3                    => NULL,
                                              X_Attribute4                    => NULL,
                                              X_Attribute5                    => NULL,
                                              X_Attribute6                    => NULL,
                                              X_Attribute7                    => NULL,
                                              X_Attribute8                    => NULL,
                                              X_Attribute9                    => NULL,
                                              X_Attribute10                   => NULL,
                                              X_Attribute11                   => NULL,
                                              X_Attribute12                   => NULL,
                                              X_Attribute13                   => NULL,
                                              X_Attribute14                   => NULL,
                                              X_Attribute15                   => NULL
                                      );
          COMMIT;
    END IF;
  END LOOP;
  FND_FILE.put_line( FND_FILE.LOG,'* Termino de Processamento com : ' || TO_CHAR(nmbContador) || ' LIDOS e com ' || TO_CHAR(nmbProcessados) || ' processados.');   
  RETCODE := 0;
END setPartNumbers;

/*
#############################################################################
#
# Procedures/Functions Oracle General Leadger
#
#############################################################################
*/
FUNCTION getCodeCombination (P_SEGMENT1 IN APPS.GL_CODE_COMBINATIONS.SEGMENT1%TYPE, 
                             P_SEGMENT2 IN APPS.GL_CODE_COMBINATIONS.SEGMENT2%TYPE, 
                             P_SEGMENT3 IN APPS.GL_CODE_COMBINATIONS.SEGMENT3%TYPE, 
				             P_SEGMENT4 IN APPS.GL_CODE_COMBINATIONS.SEGMENT4%TYPE ) RETURN NUMBER AS
  bolCombinacao                        BOOLEAN;
  nmbCodeCombId                        APPS.GL_CODE_COMBINATIONS_KFV.code_combination_id%TYPE;
  nmbIdFlexNum                         APPS.FND_ID_FLEX_STRUCTURES.ID_FLEX_NUM%TYPE;
  strSegmentosConcatenados             APPS.GL_CODE_COMBINATIONS_KFV.CONCATENATED_SEGMENTS%TYPE;
  strMensagemDeErro                    VARCHAR2(240);

BEGIN
  strSegmentosConcatenados := p_segment1||'.'||p_segment2||'.'||p_segment3||'.'||p_segment4;
  BEGIN
    SELECT id_flex_num    INTO nmbIdFlexNum
      FROM apps.fnd_id_flex_structures
     WHERE id_flex_code            = 'GL#'
       AND id_flex_structure_code  = 'COBRA';
  EXCEPTION
  WHEN OTHERS THEN
    nmbIdFlexNum := NULL;
  END;
  BEGIN
    SELECT code_combination_id    INTO nmbCodeCombId
      FROM apps.gl_code_combinations_kfv
     WHERE concatenated_segments = strSegmentosConcatenados;
  EXCEPTION
  WHEN OTHERS THEN
    nmbCodeCombId := NULL;
  END;
  IF nmbCodeCombId IS NOT NULL THEN
      RETURN nmbCodeCombId; 
  ELSE
    bolCombinacao      := APPS.FND_FLEX_KEYVAL.VALIDATE_SEGS (operation 	          => 'CHECK_COMBINATION',
                                                               appl_short_name        => 'SQLGL',
                                                               key_flex_code          => 'GL#',
                                                               structure_number       => nmbIdFlexNum,
                                                               concat_segments        => strSegmentosConcatenados
                                                               );
    strMensagemDeErro := APPS.FND_FLEX_KEYVAL.ERROR_MESSAGE;

    IF bolCombinacao THEN
      bolCombinacao    := APPS.FND_FLEX_KEYVAL.VALIDATE_SEGS  (operation             => 'CREATE_COMBINATION',
                                                               appl_short_name       => 'SQLGL',
                                                               key_flex_code         => 'GL#',
                                                               structure_number      => nmbIdFlexNum,
                                                               concat_segments       => strSegmentosConcatenados 
															   );
          strMensagemDeErro := strMensagemDeErro || '^' || APPS.FND_FLEX_KEYVAL.ERROR_MESSAGE;

      IF bolCombinacao THEN
        SELECT code_combination_id           INTO nmbCodeCombId
          FROM apps.gl_code_combinations_kfv
        WHERE concatenated_segments = strSegmentosConcatenados;
      ELSE
	   nmbCodeCombId := null;
      END IF;
    ELSE
	   nmbCodeCombId := null;
    END IF;
  END IF;
EXCEPTION
WHEN OTHERS THEN
  FND_FILE.put_line( FND_FILE.LOG,SQLCODE||' '||SQLERRM);
END getCodeCombination;
/*
#############################################################################
#
# Procedures/Functions Oracle Receivables
#
#############################################################################
*/
FUNCTION getValorImposto  (p_customer_trx_id    IN APPS.RA_CUSTOMER_TRX_ALL.customer_trx_id%TYPE, p_imposto IN VARCHAR2) RETURN NUMBER
 AS
  nmbValorImposto                        NUMBER:=0;
 BEGIN
   SELECT SUM (nvl(rctla.extended_amount,0)) INTO nmbValorImposto
     FROM APPS.RA_CUSTOMER_TRX_LINES_ALL  RCTLA,
          APPS.AR_VAT_TAX_ALL             VAT
    WHERE rctla.customer_trx_id = p_customer_trx_id 
      AND rctla.line_type       = 'TAX'
      AND rctla.vat_tax_id      = vat.vat_tax_id
      AND vat.tax_code LIKE  p_imposto;
      return nmbValorImposto;
 END getValorImposto;
FUNCTION getCliente         (p_customer_id         IN APPS.HZ_CUST_ACCOUNTS.cust_account_id %TYPE) RETURN VARCHAR2
AS
 strRetorno                 VARCHAR2(32767);
BEGIN
 SELECT hp.party_number || '-' || hp.party_name || ' (' || hp.address1 || ')' INTO strRetorno
   FROM APPS.HZ_CUST_ACCOUNTS           HCA,
        APPS.HZ_PARTIES                 HP
  WHERE hca.party_id             = hp.party_id
    AND hca.cust_account_id      = p_customer_id;
  RETURN strRetorno;    
EXCEPTION
  WHEN OTHERS THEN
      RETURN strRetorno;
END getCliente;
PROCEDURE setRecebimentos    (errbuf               OUT VARCHAR2             ,
                              retcode              OUT VARCHAR2             ,
                              p_customer_id         IN APPS.HZ_CUST_ACCOUNTS.cust_account_id %TYPE, 
                              p_nome_do_arquivo     IN VARCHAR2 DEFAULT 'ContasaReceber.xls') 
AS
-- exec dbms_java.grant_permission(UPPER('APPS'),'SYS:java.io.FilePermission','/transferencia/interface/*','READ,WRITE');
-- exec dbms_java.grant_permission(UPPER('APPS'),'SYS:java.io.FilePermission','/transferencia/interface/*','READ,WRITE');
   strNLS_LANGUAGE                  v$nls_parameters.value %TYPE;
   strNLS_TERRITORY                 v$nls_parameters.value %TYPE;
   typAttributeGlobal               AR_RECEIPT_API_PUB.global_attribute_rec_type;
   consNmbUserId                    CONSTANT NUMBER                                        := FND_PROFILE.VALUE('COBRA:USUARIO_INTERFACE');
   consOrgId                        CONSTANT NUMBER                                        := FND_PROFILE.VALUE('ORG_ID');
   consCurrency                     CONSTANT FND_CURRENCIES.CURRENCY_CODE %TYPE            := 'BRL';
   consSetOfBook                    CONSTANT NUMBER                                        := FND_PROFILE.VALUE('GL_SET_OF_BKS_ID');
   consReceiptMethods               CONSTANT AR_RECEIPT_METHODS.RECEIPT_METHOD_ID%TYPE     := 4106;
   consAdjISS                       CONSTANT ar_receivables_trx_all.receivables_trx_id%TYPE:= 1004;
   consAdjINSS                      CONSTANT ar_receivables_trx_all.receivables_trx_id%TYPE:= 1002;   
   consAdjIR                        CONSTANT ar_receivables_trx_all.receivables_trx_id%TYPE:= 1003;   
   consAdjCOFINS                    CONSTANT ar_receivables_trx_all.receivables_trx_id%TYPE:= 1115;   
   consAdjCSLL                      CONSTANT ar_receivables_trx_all.receivables_trx_id%TYPE:= 1113;      
   consAdjPASEP                     CONSTANT ar_receivables_trx_all.receivables_trx_id%TYPE:= 1074;      
   strNumReceipt                    VARCHAR2(100)                                          := '';
   consCharNao                      CONSTANT CHAR(1)                                       := 'N';
   consDataGL                       CONSTANT DATE                                          := TRUNC(SYSDATE,'DD');
   consCharSim                      CONSTANT CHAR(1)                                       := 'Y';
   consCharFalse                    CONSTANT CHAR(1)                                       := 'F';
   nmbRetorno                       NUMBER                                                 := -1;
   x_exception_msg                  VARCHAR2(4000);
   l_msg_data                       VARCHAR2(240);
   strStatus                        VARCHAR2(1000);
   strReturnStatus                  VARCHAR2(4000);
   strCabecalhoPadrao               VARCHAR2(4000)                                         := 'NOTA^VALOR^DATANF^LOCAL^ISS^INSS^IR^COFINS^CSLL^PASEP^SALDO LIQUIDO^CONTRATO^CODIGO^DATA^';
   strRegistro                      VARCHAR2(4000);
   strCaminhoDefault                VARCHAR2(4000)                                         :='/transferencia/interface/';
   strArquivoPadrao                 VARCHAR2(4000);
   nmbCustomerTrxId                 RA_CUSTOMER_TRX_ALL.CUSTOMER_TRX_ID            %TYPE;
   nmbbill_to_site_use_id           RA_CUSTOMER_TRX_ALL.bill_to_site_use_id        %TYPE; 
   nmbpayment_schedule_id           AR_PAYMENT_SCHEDULES_ALL.payment_schedule_id   %TYPE;
   nmbremit_bank_id                 ar_receipt_method_accounts_all.bank_account_id %TYPE;
   nmbcash_receipt_id               NUMBER;
   nmbcount                         NUMBER;
   nmbContador                      NUMBER                                                 := 0;
   bolCabecalho                     BOOLEAN                                                := FALSE;
   bolErro                          BOOLEAN                                                := FALSE;
   TYPE regBaixa IS RECORD        ( CUSTOMER_TRX_ID                        NUMBER,
                                    SITE_USE_ID                            NUMBER,
									                  PAYMENT_SCHEDULE_ID                    NUMBER,
                                    VALOR_NNF                              NUMBER,
                                    VALOR_ISS                              NUMBER,
                                    VALOR_INSS                             NUMBER,
                                    VALOR_IR                               NUMBER,
                                    VALOR_COFINS                           NUMBER,
                                    VALOR_CSLL                             NUMBER,
                                    VALOR_PASEP                            NUMBER,
                                    SALDO_LIQUIDO                          NUMBER,
                                    NUMERO_CONTRATO                        VARCHAR2(100),
                                    TRX_NUMBER                             VARCHAR2(100),
                                    TRX_DATE                               DATE
                                    );
  TYPE TabTypRegBaixa               IS TABLE OF regBaixa;
  registroBaixa                     regBaixa;
  tabtypTitulos                     TABTYPREGBAIXA := TABTYPREGBAIXA();
FUNCTION GETNUMERODANOTA(p_registro IN VARCHAR2) RETURN VARCHAR2
AS
 nmbCustomer_Trx_Id                             ra_customer_trx_all.customer_trx_id          %TYPE;
 nmbBatch_Source_Id                             ra_batch_sources_all.batch_source_id         %TYPE;
 nmbbill_to_site_use_id                         ra_customer_trx_all.bill_to_site_use_id      %TYPE;
 nmbTotal                                       NUMBER;
 datEmissaoNf                                   DATE;
 nmbMontanteAplicado                            NUMBER;                     
 strRetorno                                     VARCHAR2(100):= '-1^-1^-1';
BEGIN

 BEGIN 
    FND_FILE.put_line( FND_FILE.LOG,'* Pesquisando a Origem da Nota Fiscal: ' ||  cobra_utility.getPiece(p_registro,'^',4));
    SELECT BATCH_SOURCE_ID  INTO nmbBatch_Source_Id 
      FROM ra_batch_sources_all 
     WHERE NAME  = ('I-' || cobra_utility.getPiece(p_registro,'^',4) || '-SERVICO'); -- I-BRA-SERVICO
 EXCEPTION
  WHEN OTHERS THEN
     FND_FILE.put_line( FND_FILE.LOG,'* Problema na Origem da Nota Fiscal: ' ||  cobra_utility.getPiece(p_registro,'^',4));
     RETURN '-1^0';
 END;
 
 datEmissaoNf := TO_DATE(cobra_utility.getPiece(p_registro,'^',3),'DD-MON-RR');
 FND_FILE.put_line( FND_FILE.LOG,'* Pesquisando a Data da Nota Fiscal: ' ||  TO_CHAR(datEmissaoNf,'DD/MM/YYYY')); 
 BEGIN 
    SELECT rcta.customer_trx_id,rcta.bill_to_site_use_id, apsa.payment_schedule_id, SUM( rctla.quantity_invoiced *  rctla.unit_selling_price ) AS TOTAL
      INTO nmbCustomer_Trx_Id, nmbbill_to_site_use_id,nmbpayment_schedule_id,  nmbTotal
      FROM RA_CUSTOMER_TRX_ALL            RCTA,
           RA_CUSTOMER_TRX_LINES_ALL      RCTLA,
		       ar_payment_schedules_all       APSA
     WHERE APSA.customer_trx_id         = RCTA.customer_trx_id
	   AND RCTLA.customer_trx_id          = RCTA.customer_trx_id
       AND RCTA.BATCH_SOURCE_ID         = nmbBatch_Source_Id 
       AND RCTA.BILL_TO_CUSTOMER_ID     = p_customer_id 
       AND trunc(RCTA.TRX_DATE,'DD')    = datEmissaoNf
       AND RCTA.TRX_NUMBER              = TO_CHAR(REGEXP_REPLACE(cobra_utility.getPiece(p_registro,'^',1), '[^[:digit:]]'))
    GROUP BY rcta.customer_trx_id,rcta.bill_to_site_use_id,apsa.payment_schedule_id;
 EXCEPTION
   WHEN OTHERS THEN
       FND_FILE.put_line( FND_FILE.LOG,'* Nota Fiscal não localizada ou inexistente: ' ||  TO_CHAR(REGEXP_REPLACE(cobra_utility.getPiece(p_registro,'^',1), '[^[:digit:]]'))); 
       RETURN '-1^-1^-1';
 END;
 BEGIN
   SELECT SUM(ARA.AMOUNT_APPLIED) INTO nmbMontanteAplicado
     FROM RA_CUSTOMER_TRX_ALL            RCT, 
          AR_RECEIVABLE_APPLICATIONS_ALL ARA
    WHERE ARA.STATUS                  = 'APP'
      AND ARA.APPLIED_CUSTOMER_TRX_ID = RCT.CUSTOMER_TRX_ID
      AND RCT.CUSTOMER_TRX_ID         = nmbCustomer_Trx_Id;
 EXCEPTION
   WHEN OTHERS THEN
        nmbMontanteAplicado := 0;
 END;
 IF TO_NUMBER(cobra_utility.getPiece(p_registro,'^',2), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''')  <> (nmbtotal-nmbMontanteAplicado) THEN
    FND_FILE.put_line( FND_FILE.LOG,'* Existe aplicação para esta Nota Fiscal,sendo Impossível continuar.');
    RETURN '-1^-2^-1';
 END IF;
 RETURN TO_CHAR(nmbBatch_Source_Id) || '^' || TO_CHAR(nmbCustomer_Trx_Id) || '^' || TO_CHAR(nmbbill_to_site_use_id) || '^' || TO_CHAR(nmbpayment_schedule_id);
EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20001,'SQL = ' || SQLERRM);
END  GETNUMERODANOTA;
PROCEDURE SETAJUSTE(P_TIPO IN ar_receivables_trx_all.receivables_trx_id%TYPE,p_type_line IN VARCHAR2,  P_LANCAMENTO IN VARCHAR2) 
AS

 strAdjMsglist                  VARCHAR2(1000);
 nmbvalidation_level            NUMBER(4) := FND_API.G_VALID_LEVEL_FULL;
 rwtAdjrec                      ar_adjustments%rowtype;
 typAdjnewadjust_number         ar_adjustments.adjustment_number   %TYPE;
 typnew_adjust_id               ar_adjustments.adjustment_id       %TYPE;
 typAdjold_adjust_id            ar_adjustments.adjustment_id       %TYPE;
 strcalled_from                 VARCHAR2(25) := 'BR_REMIT';

BEGIN 
  rwtAdjrec.acctd_amount               := -1 * COBRA_UTILITY.GETPIECE(P_LANCAMENTO,'^',3);
  rwtAdjrec.ADJUSTMENT_ID              := NULL;
  rwtAdjrec.ADJUSTMENT_NUMBER          := NULL;
  rwtAdjrec.ADJUSTMENT_TYPE            := 'M'; 
  rwtAdjrec.amount                     := -1 * COBRA_UTILITY.GETPIECE(P_LANCAMENTO,'^',3);  
  rwtAdjrec.CREATED_BY                 := consNmbUserId;        
  rwtAdjrec.CREATED_FROM               :=  strcalled_from ;
  rwtAdjrec.LAST_UPDATE_LOGIN          := consNmbUserId;        
  rwtAdjrec.CREATION_DATE              := SYSDATE;
  rwtAdjrec.GL_DATE                    := consDataGL;
  rwtAdjrec.GL_POSTED_DATE             := consDataGL;
  rwtAdjrec.LAST_UPDATE_DATE           := SYSDATE;
  rwtAdjrec.POSTING_CONTROL_ID         := -1; -- -3
  rwtAdjrec.SET_OF_BOOKS_ID            := consSetOfBook;
  rwtAdjrec.ORG_ID                     := consOrgId;
  rwtAdjrec.TYPE                       := p_type_line;  
  rwtAdjrec.LAST_UPDATED_BY            := consNmbUserId;        
  rwtAdjrec.customer_trx_id            := COBRA_UTILITY.GETPIECE(P_LANCAMENTO,'^',1);
  rwtAdjrec.payment_schedule_id        := COBRA_UTILITY.GETPIECE(P_LANCAMENTO,'^',2);
  rwtAdjrec.receivables_trx_id         := p_tipo;
  rwtAdjrec.apply_date                 := consDataGL;
  rwtAdjrec.STATUS                     := 'A'; -- 'W'
  rwtAdjrec.postable                   := 'N';
  --rwtAdjrec.ASSOCIATED_CASH_RECEIPT_ID := COBRA_UTILITY.GETPIECE(P_LANCAMENTO,'^',4);
  rwtAdjrec.COMMENTS                   := 'Realizado em ' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') || ' POR ' || FND_PROFILE.VALUE('USER_NAME');
  
  FND_FILE.put_line( FND_FILE.LOG,'Criando o Ajuste... com ' || p_tipo || ' e valor ' || rwtAdjrec.amount);
  AR_ADJUST_PUB.Create_Adjustment ( p_api_name              => 'AR_ADJUST_PUB',
                                    p_api_version           => 1.0,
                                    p_init_msg_list         => FND_API.G_TRUE,
                                    p_commit_flag           => FND_API.G_TRUE,
                                    p_validation_level      => FND_API.G_VALID_LEVEL_FULL,
                                    p_msg_count             => nmbcount,
                                    p_msg_data              => l_msg_data,
                                    p_return_status         => strReturnStatus,
                                    p_adj_rec               => rwtAdjrec,
                                    p_chk_approval_limits   => FND_API.G_TRUE,
                                    p_check_amount          => FND_API.G_TRUE,
                                    p_move_deferred_tax     => consCharSim,
                                    p_new_adjust_number     => typAdjnewadjust_number,
                                    p_new_adjust_id         => typnew_adjust_id,
                                    p_called_from           => strcalled_from,
                                    p_old_adjust_id         => typAdjold_adjust_id
                                  );
                                  
    FND_FILE.put_line( FND_FILE.LOG,'Saindo do Ajuste...' || l_msg_data || ' com status: ' ||strReturnStatus);
    IF strReturnStatus <> 'S' THEN
         FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
         FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
         FND_FILE.put_line( FND_FILE.LOG,'*       Processo de Criação de Ajustes sendo executado com o seguinte erro:                    *');
         FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
         FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
       FOR I in 1..nmbcount LOOP
          FND_FILE.put_line( FND_FILE.LOG,SUBSTR(FND_MSG_PUB.GET(P_ENCODED => FND_API.G_FALSE),1,100));
       END LOOP;
       RAISE_APPLICATION_ERROR(-20001,'Problema em AR_ADJUST_PUB.Create_Adjustment: Impedem a continuidade do PROCESSO CASH_RECEIPTS.');
       retcode := 2;
    END IF;

/*    
    rwtAdjrec.ADJUSTMENT_ID       := typnew_adjust_id;
    rwtAdjrec.ADJUSTMENT_NUMBER   := typAdjnewadjust_number;
    typAdjold_adjust_id           := typnew_adjust_id;    
   AR_ADJUST_PUB.Modify_Adjustment( p_api_name       => 'AR_ADJUST_PUB',
                                    p_api_version    => 1.0,
                                    p_msg_count      => nmbcount,
                                    p_msg_data       => l_msg_data,
                                    p_return_status  => strReturnStatus,
                                    p_adj_rec        => rwtAdjrec,
                                    p_old_adjust_id  => typnew_adjust_id
                                   ); 
      FND_FILE.put_line( FND_FILE.LOG,'Aprovando o ajuste...');
      rwtAdjrec.ADJUSTMENT_ID       := typnew_adjust_id;
      rwtAdjrec.ADJUSTMENT_NUMBER   := typAdjnewadjust_number;
      typAdjold_adjust_id           := typnew_adjust_id;

    AR_ADJUST_PUB.Approve_Adjustment( p_api_name            => 'AR_ADJUST_PUB', 
                                      p_api_version         => 1.0, 
                                      p_init_msg_list	      => FND_API.G_FALSE,
	                                    p_commit_flag		      => FND_API.G_TRUE,
                                      p_validation_level    => FND_API.G_VALID_LEVEL_FULL,
                                      p_msg_count           => nmbcount,
                                      p_msg_data            => l_msg_data,
                                      p_return_status       => strReturnStatus,
                                      p_adj_rec             => rwtAdjrec, 
                                      p_chk_approval_limits => FND_API.G_TRUE,
                                      p_move_deferred_tax   => 'N',
                                      p_old_adjust_id       => typnew_adjust_id); 



    FND_FILE.put_line( FND_FILE.LOG,'Saindo Aprovando o ajuste.....' || l_msg_data || ' com status: ' ||strReturnStatus || ' cin ' || nmbcount);
    IF strReturnStatus <> 'S' THEN
         FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
         FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
         FND_FILE.put_line( FND_FILE.LOG,'*       Processo de Criação de Ajustes sendo executado com o seguinte erro:                    *');
         FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
         FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
       FOR I in 1..nmbcount LOOP
          FND_FILE.put_line( FND_FILE.LOG,SUBSTR(FND_MSG_PUB.GET(P_ENCODED => FND_API.G_FALSE),1,255));
       END LOOP;
       RAISE_APPLICATION_ERROR(-20001,'Problema na aplicação impedem a continuidade');
       retcode := 2;
    END IF;
    */
EXCEPTION
 WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001,'Problema em SETAJUSTE impedem a continuação da Aplicação. (' || SQLERRM || ')');
END SETAJUSTE;  
BEGIN
   mo_global.set_policy_context('S',consOrgId);
   FND_GLOBAL.APPS_INITIALIZE(USER_ID    => consNmbUserId, RESP_ID => 20678, RESP_APPL_ID => 222);
   
   -- SELECT VALUE INTO strNLS_LANGUAGE    FROM v$nls_parameters  WHERE PARAMETER = 'NLS_LANGUAGE';
   -- SELECT VALUE INTO strNLS_TERRITORY   FROM v$nls_parameters  WHERE PARAMETER = 'NLS_TERRITORY';
   -- DBMS_SESSION.SET_NLS('NLS_LANGUAGE'  ,'BRAZILIAN PORTUGUESE'); 
   -- DBMS_SESSION.SET_NLS('NLS_TERRITORY' ,'BRAZIL');  
  BEGIN
  SELECT bank_account_id  INTO nmbremit_bank_id
    FROM ar_receipt_method_accounts_all  
   WHERE receipt_method_id = consReceiptMethods
     AND PRIMARY_FLAG      = 'Y'
     AND SYSDATE BETWEEN NVL(start_date,SYSDATE-1) AND NVL(end_date  ,SYSDATE+1);
  EXCEPTION
    WHEN OTHERS THEN
       RETCODE := 2;
       FND_FILE.put_line( FND_FILE.LOG,'* Problema na identificação do Banco.');
       RAISE_APPLICATION_ERROR (-20001,'Identificação do Banco Não foi possível. Contacte Analista Funcional com codigo (' || SQLERRM || ')');
  END;
  FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
  FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
  FND_FILE.put_line( FND_FILE.LOG,'*                Iniciando o processo de Recebimento Automático COBRA                          *');
  FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
  FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
  BEGIN
    strArquivoPadrao := COBRA_UTILITY.EXCELTOSTRING(strCaminhoDefault || p_nome_do_arquivo);
    FND_FILE.put_line( FND_FILE.LOG,'* ' || strCaminhoDefault || p_nome_do_arquivo);
  EXCEPTION
    WHEN OTHERS THEN
        FND_FILE.put_line( FND_FILE.LOG,'Arquivo: ' || strCaminhoDefault || p_nome_do_arquivo || ' não foi localizado no local definido.');
        RETCODE := 1;
        RAISE_APPLICATION_ERROR (-20001,'Arquivo: ' || strCaminhoDefault || p_nome_do_arquivo || ' não foi localizado no local definido.');
    RETURN;
  END;
  FND_FILE.put_line( FND_FILE.LOG,'* Efetuando a leitura do arquivo: ' || strArquivoPadrao);
  nmbContador := 0;
  FOR reg IN (SELECT column_value FROM TABLE(COBRA_UTILITY.getArquivoCollection('INTERFACE',strArquivoPadrao))) LOOP
      IF nmbContador = 0 THEN
         IF UPPER(strCabecalhoPadrao) <> UPPER(reg.column_value) THEN
             FND_FILE.put_line( FND_FILE.LOG,'* Padrão: ' || UPPER(strCabecalhoPadrao));
             FND_FILE.put_line( FND_FILE.LOG,'* Lido  : ' || UPPER(reg.column_value));
             bolCabecalho := TRUE;
         END IF;
      END IF;
      nmbContador := nmbContador + 1;
      IF nmbContador > 1 THEN 
         strRegistro           := GETNUMERODANOTA(reg.column_value);
         nmbCustomerTrxId      := COBRA_UTILITY.getPiece(strRegistro,'^',2);
         nmbbill_to_site_use_id:= COBRA_UTILITY.getPiece(strRegistro,'^',3);
		     nmbpayment_schedule_id:= COBRA_UTILITY.getPiece(strRegistro,'^',4);
         
         IF nmbCustomerTrxId < 0 THEN
            FND_FILE.put_line( FND_FILE.LOG,'* Nota Não Localizada: ' || reg.column_value);
            bolErro  := true;
         ELSE
            tabtypTitulos.EXTEND;
            tabtypTitulos(tabtypTitulos.LAST).CUSTOMER_TRX_ID    := nmbCustomerTrxId;
            tabtypTitulos(tabtypTitulos.LAST).SITE_USE_ID        := nmbbill_to_site_use_id;
            tabtypTitulos(tabtypTitulos.LAST).PAYMENT_SCHEDULE_ID:= nmbpayment_schedule_id;
            tabtypTitulos(tabtypTitulos.LAST).VALOR_NNF          := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',2), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).VALOR_ISS          := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',5), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).VALOR_INSS         := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',6), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).VALOR_IR           := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',7), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).VALOR_COFINS       := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',8), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).VALOR_CSLL         := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',9), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).VALOR_PASEP        := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',10), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');            
            tabtypTitulos(tabtypTitulos.LAST).SALDO_LIQUIDO      := TO_NUMBER(cobra_utility.getPiece(reg.column_value,'^',11), '999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''');
            tabtypTitulos(tabtypTitulos.LAST).NUMERO_CONTRATO    := REPLACE(cobra_utility.getPiece(reg.column_value,'^',12),'.','');
            tabtypTitulos(tabtypTitulos.LAST).TRX_NUMBER         := TO_CHAR(REGEXP_REPLACE(cobra_utility.getPiece(reg.column_value,'^',1), '[^[:digit:]]'));
            tabtypTitulos(tabtypTitulos.LAST).TRX_DATE           := TO_DATE(cobra_utility.getPiece(reg.column_value,'^',3),'DD-MON-RR');
         END IF;
      END IF;
  END LOOP;
  IF bolErro OR bolCabecalho THEN
     FND_FILE.put_line( FND_FILE.LOG,'* Arquivo recebido fora das especificações acordadas: ' || strCabecalhoPadrao);   
     RETCODE := 1;
     RETURN;
  END IF;
  FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
  FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
  FND_FILE.put_line( FND_FILE.LOG,'*                   Processando os Recebimento Automático COBRA                                *');
  FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
  FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
  
  -- mo_global.set_policy_context('S',consOrgId);
  -- FND_GLOBAL.APPS_INITIALIZE(USER_ID    => consNmbUserId, RESP_ID => 20678, RESP_APPL_ID => 222);

  FOR regInt IN tabtypTitulos.FIRST..tabtypTitulos.LAST LOOP
     strNumReceipt  := 'RCT-' || TO_CHAR(sysdate,'YYYYMMDDHH24MISS');
     AR_RECEIPT_API_PUB.CREATE_CASH( p_api_version                  => 1.0,
                                     p_init_msg_list                => FND_API.G_TRUE,
                                     p_commit                       => FND_API.G_TRUE,
                                     p_validation_level             => FND_API.G_VALID_LEVEL_FULL,
                                     p_usr_currency_code            => consCurrency,
                                     p_usr_exchange_rate_type       => NULL,
                                     p_exchange_rate_type           => NULL,
                                     p_exchange_rate                => NULL,
                                     p_exchange_rate_date           => NULL,
                                     p_currency_code                => consCurrency ,
                                     p_amount                       => tabtypTitulos(regInt).SALDO_LIQUIDO,
                                     p_factor_discount_amount       => NULL,
                                     p_receipt_number               => strNumReceipt,
                                     p_receipt_date                 => consDataGL,
                                     p_gl_date                      => consDataGL,
                                     p_maturity_date                => NULL,
                                     p_postmark_date                => NULL,
                                     p_customer_id                  => p_customer_id,
                                     p_customer_site_use_id         => tabtypTitulos(regInt).SITE_USE_ID,
                                     p_customer_bank_account_id     => null, 
                                     p_remittance_bank_account_id   => nmbremit_bank_id,
                                     p_deposit_date                 => consDataGL,
                                     p_receipt_method_id            => consReceiptMethods,
                                     p_receipt_method_name          => NULL,
                                     p_doc_sequence_value           => NULL,
                                     p_ussgl_transaction_code       => NULL,
                                     p_anticipated_clearing_date    => NULL,
                                     p_issuer_name                  => NULL,
                                     p_issue_date                   => NULL,
                                     p_issuer_bank_branch_id        => NULL,
                                     p_called_from                  => 'BR_REMIT',
                                     p_comments                     => 'Gerado às ' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') || ' O RECEBIMENTO: ' || strNumReceipt,
                                     x_msg_count                    => nmbcount,
                                     x_msg_data                     => l_msg_data,
                                     x_return_status                => strReturnStatus,                                     
                                     p_cr_id                        => nmbcash_receipt_id 
                                    );
    IF strReturnStatus <> 'S' THEN
       FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
       FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
       FND_FILE.put_line( FND_FILE.LOG,'*                   Processando os Recebimento CREATE_CASH                                     *');
       FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
       FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
       FOR I in 1..nmbcount LOOP
           FND_FILE.put_line( FND_FILE.LOG,SUBSTR(FND_MSG_PUB.GET(P_ENCODED => FND_API.G_FALSE),1,100));
           RETCODE := 1;
       END LOOP;
       RAISE_APPLICATION_ERROR(-20001,'Problema na aplicação impedem a continuidade');
    ELSE
      FND_FILE.put_line( FND_FILE.LOG,'* Efetuado a criação : ' || strNumReceipt || ' para a NF: ' || tabtypTitulos(regInt).CUSTOMER_TRX_ID);
    END IF;
/*
*/
    FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
    FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
    FND_FILE.put_line( FND_FILE.LOG,'*           Efetuando os ajustes necessários para o Recebimento                                *');
    FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
    FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
	IF tabtypTitulos(regInt).VALOR_CSLL > 0 THEN
     FND_FILE.put_line( FND_FILE.LOG,'Efetuando ajuste em valor de VALOR_CSLL.');
	   strRegistro := TO_CHAR(tabtypTitulos(regInt).CUSTOMER_TRX_ID) || '^' || tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID || '^' || tabtypTitulos(regInt).VALOR_CSLL || '^' || nmbcash_receipt_id;
	   SETAJUSTE(consAdjCSLL, 'LINE',strRegistro);
	END IF;		
	IF tabtypTitulos(regInt).VALOR_ISS > 0 THEN
     FND_FILE.put_line( FND_FILE.LOG,'* Informado valor na coluna INSS.');
	   strRegistro := TO_CHAR(tabtypTitulos(regInt).CUSTOMER_TRX_ID) || '^' || tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID || '^' || tabtypTitulos(regInt).VALOR_ISS || '^' || nmbcash_receipt_id;
	   SETAJUSTE(consAdjISS,'LINE', strRegistro);
	END IF;
	IF tabtypTitulos(regInt).VALOR_INSS > 0 THEN
     FND_FILE.put_line( FND_FILE.LOG,'Efetuando ajuste em valor de VALOR_INSS.');
	   strRegistro := TO_CHAR(tabtypTitulos(regInt).CUSTOMER_TRX_ID) || '^' || tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID || '^' || tabtypTitulos(regInt).VALOR_INSS || '^' || nmbcash_receipt_id;
	   SETAJUSTE(consAdjINSS, 'LINE',strRegistro);
	END IF;
	IF tabtypTitulos(regInt).VALOR_IR > 0 THEN
     FND_FILE.put_line( FND_FILE.LOG,'Efetuando ajuste em valor de VALOR_IR.');
	   strRegistro := TO_CHAR(tabtypTitulos(regInt).CUSTOMER_TRX_ID) || '^' || tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID || '^' || tabtypTitulos(regInt).VALOR_IR || '^' || nmbcash_receipt_id;
	   SETAJUSTE(consAdjIR, 'LINE',strRegistro);
	END IF;
	IF tabtypTitulos(regInt).VALOR_COFINS > 0 THEN
     FND_FILE.put_line( FND_FILE.LOG,'Efetuando ajuste em valor de VALOR_COFINS.');
	   strRegistro := TO_CHAR(tabtypTitulos(regInt).CUSTOMER_TRX_ID) || '^' || tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID || '^' || tabtypTitulos(regInt).VALOR_COFINS || '^' || nmbcash_receipt_id;
	   SETAJUSTE(consAdjCOFINS, 'LINE',strRegistro);
	END IF;
	IF tabtypTitulos(regInt).VALOR_PASEP > 0 THEN
     FND_FILE.put_line( FND_FILE.LOG,'Efetuando ajuste em valor de VALOR_PASEP.');
	   strRegistro := TO_CHAR(tabtypTitulos(regInt).CUSTOMER_TRX_ID) || '^' || tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID || '^' || tabtypTitulos(regInt).VALOR_PASEP|| '^' || nmbcash_receipt_id;
	   SETAJUSTE(consAdjPASEP,'LINE', strRegistro);
	END IF;	
  typAttributeGlobal.global_attribute_category := 'JL.BR.ARXRWMAI.Additional Info';
  typAttributeGlobal.global_attribute1         := tabtypTitulos(regInt).SALDO_LIQUIDO;
  typAttributeGlobal.global_attribute2         := 'TOTAL';
  typAttributeGlobal.global_attribute3         := '0';
  typAttributeGlobal.global_attribute4         := '0';
  typAttributeGlobal.global_attribute5         := 'WRITEOFF';
  typAttributeGlobal.global_attribute6         := 'SJ';
  typAttributeGlobal.global_attribute7         := TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS');
  typAttributeGlobal.global_attribute8         := TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS');
  typAttributeGlobal.global_attribute11        := TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS');
  
   AR_RECEIPT_API_PUB.APPLY ( 	p_api_version                  => 1.0,
                                p_init_msg_list                => FND_API.G_FALSE,
                                p_commit                       => FND_API.G_TRUE,
                                p_validation_level             => FND_API.G_VALID_LEVEL_FULL,
                                x_return_status                => strReturnStatus,
                                x_msg_count                    => nmbcount,
                                x_msg_data                     => l_msg_data,
                                --  Receipt application parameters.
                                p_cash_receipt_id              => nmbcash_receipt_id,
                                -- p_receipt_number               => consNumReceipt,
                                p_customer_trx_id              => tabtypTitulos(regInt).CUSTOMER_TRX_ID,
                                p_installment                  => NULL,
                                p_applied_payment_schedule_id  => tabtypTitulos(regInt).PAYMENT_SCHEDULE_ID,
                                p_amount_applied               => tabtypTitulos(regInt).SALDO_LIQUIDO,
                                p_trx_number                   =>  tabtypTitulos(regInt).TRX_NUMBER,
                                p_amount_applied_from          => NULL,
                                p_trans_to_receipt_rate        => NULL,
                                p_discount                     => NULL,
                                p_apply_date                   => consDataGL,
                                p_apply_gl_date                => consDataGL,
                                p_ussgl_transaction_code       => NULL,
                                p_customer_trx_line_id	       => NULL,
                                p_line_number                  => NULL,
                                p_show_closed_invoices         => consCharSim,
                                p_called_from                  => 'BR_REMIT',
                                p_move_deferred_tax            => 'Y',
                                p_link_to_trx_hist_id          => NULL,
                                p_attribute_rec                => NULL,
                                p_global_attribute_rec         =>typAttributeGlobal,
                                p_comments                     => 'Aplicação final às ' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
							                );
    FND_FILE.put_line( FND_FILE.LOG,'Efetuando aplicação no Recebimento : ' || strReturnStatus || ' com ' || l_msg_data);
    IF strReturnStatus <> 'S' THEN
       FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
       FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
       FND_FILE.put_line( FND_FILE.LOG,'*                   Processando os Recebimento APPLY                                           *');
       FND_FILE.put_line( FND_FILE.LOG,'*                                                                                              *');
       FND_FILE.put_line( FND_FILE.LOG,'************************************************************************************************');
       FOR I in 1..nmbcount LOOP
          FND_FILE.put_line( FND_FILE.LOG,SUBSTR(FND_MSG_PUB.GET(P_ENCODED => FND_API.G_FALSE),1,255));
       END LOOP;
       RETCODE := 1;
       RAISE_APPLICATION_ERROR(-20001,'Problema na aplicação impedem a continuidade - Aplicação.');
    END IF;

   COMMIT;
   --DBMS_SESSION.SET_NLS('NLS_LANGUAGE',strNLS_LANGUAGE); 
   -- DBMS_SESSION.SET_NLS('NLS_TERRITORY',strNLS_TERRITORY);
  END LOOP;
  
  FND_FILE.put_line( FND_FILE.LOG,'Término normal de execução da rotina às ' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
EXCEPTION
 WHEN OTHERS THEN
     FND_FILE.put_line( FND_FILE.LOG,'Término COM PROBLEMAS às ' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
     RAISE_APPLICATION_ERROR(-20001,'==> ' || SQLERRM || ' COM ' || SQLCODE);

END setRecebimentos;
/*
#############################################################################
#
# Procedures/Functions Oracle Order Management
#
#############################################################################
*/ 
FUNCTION getOrderNumber     (p_numero_da_nff       IN APPS.RA_CUSTOMER_TRX_ALL.TRX_NUMBER%TYPE, p_organization_id    IN APPS.MTL_PARAMETERS.ORGANIZATION_ID%TYPE) RETURN VARCHAR2
AS
 strRetorno                 VARCHAR2(32767);
 CURSOR C_SALES_ORDER IS
    SELECT DISTINCT  NVL(rcta.attribute13,'SC') || '.' || RCTLA.SALES_ORDER as valor
  FROM APPS.RA_CUSTOMER_TRX_ALL          RCTA,
       APPS.RA_CUSTOMER_TRX_LINES_ALL    RCTLA
 WHERE RCTLA.CUSTOMER_TRX_ID             = RCTA.CUSTOMER_TRX_ID
   AND 'LINE'                            =  RCTLA.LINE_TYPE
   AND RCTA.INTERFACE_HEADER_ATTRIBUTE10 = p_organization_id  
   AND RCTA.TRX_NUMBER                   = p_numero_da_nff;
BEGIN
  FOR reg IN C_SALES_ORDER LOOP
      strRetorno := strRetorno || reg.valor || ',';
  END LOOP;
  IF strRetorno IS NOT NULL THEN
     strRetorno := SUBSTR(strRetorno,1,LENGTH(strRetorno)-1);
  END IF;
  RETURN strRetorno;
END getOrderNumber;
FUNCTION putCloseSalesOrder (p_numero_da_ordem     IN APPS.OE_ORDER_HEADERS_ALL.ORDER_NUMBER %TYPE,p_numero_da_linha IN APPS.OE_ORDER_LINES_ALL.line_number%TYPE ) RETURN BOOLEAN
AS
typHeaderIn 						  APPS.OE_ORDER_PUB.header_rec_type;
tabTypLinhaIn 						  APPS.OE_ORDER_PUB.line_tbl_type;
tabTypActionRequestIn 			      APPS.OE_ORDER_PUB.request_tbl_type;
typHeaderOut 					      APPS.OE_ORDER_PUB.header_rec_type;
tabTypLinhaOut 						  APPS.OE_ORDER_PUB.line_tbl_type;
typHeaderValIn 				          APPS.OE_ORDER_PUB.header_val_rec_type;
tabtypHeaderAdjOut 					  APPS.OE_ORDER_PUB.header_adj_tbl_type;
tabtypHeaderAdjValOut 			      APPS.OE_ORDER_PUB.header_adj_val_tbl_type;
tabtypHeaderPriceAttOut 		      APPS.OE_ORDER_PUB.header_price_att_tbl_type;
tabtypHeaderAdjAttOut 			      APPS.OE_ORDER_PUB.header_adj_att_tbl_type;
tabtypAssocAdjOut 			          APPS.OE_ORDER_PUB.header_adj_assoc_tbl_type;
tabtypScreditOut 			          APPS.OE_ORDER_PUB.header_scredit_tbl_type;
tabtypScreditValOut 		          APPS.OE_ORDER_PUB.header_scredit_val_tbl_type;
tabtypLineValOut 					  APPS.OE_ORDER_PUB.line_val_tbl_type;
tabtypLineAdjOut 					  APPS.OE_ORDER_PUB.line_adj_tbl_type;
tabtypLineAdjValOut 				  APPS.OE_ORDER_PUB.line_adj_val_tbl_type;
tabtypLinePriceAttOut 			      APPS.OE_ORDER_PUB.line_price_att_tbl_type;
tabtypLineAdjAttOut 				  APPS.OE_ORDER_PUB.line_adj_att_tbl_type;
tabtypLineAdjAssocOut 			      APPS.OE_ORDER_PUB.line_adj_assoc_tbl_type;
tabtypLineScreditOut 				  APPS.OE_ORDER_PUB.line_scredit_tbl_type;
tabtypLineScreditValOut 		      APPS.OE_ORDER_PUB.line_scredit_val_tbl_type;
tabtypLotSerialOut 				      APPS.OE_ORDER_PUB.lot_serial_tbl_type;
tabtypLotSerialValOut 			      APPS.OE_ORDER_PUB.lot_serial_val_tbl_type;
tabtypActionReqOut 			          APPS.OE_ORDER_PUB.request_tbl_type;
strProgramUnitName 					  VARCHAR2 (100);
strStatusRetorno 					  VARCHAR2 (1000) := NULL;
nmbContador 						  NUMBER := 0;
strMensagem 						  VARCHAR2 (2000);
nmbApiVersao						  NUMBER := 1.0;
CURSOR C_ORDEM_DETALHES IS
  SELECT ooha.order_number, oola.*
   FROM APPS.OE_ORDER_LINES_ALL       OOLA, 
        APPS.OE_ORDER_HEADERS_ALL     OOHA
  WHERE OOHA.header_id                = OOLA.header_id
    AND OOHA.org_id                   = OOLA.org_id
    AND NVL (OOLA.cancelled_flag,'N') = 'N'
    AND OOHA.order_number             = p_numero_da_ordem
    AND OOLA.line_number                = p_numero_da_linha
    AND OOLA.flow_status_code           = 'AWAITING_SHIPPING';
BEGIN
 FOR reg IN C_ORDEM_DETALHES LOOP
     tabTypLinhaIn (1)                  := APPS.OE_ORDER_PUB.g_miss_line_rec;
     tabTypLinhaIn (1).line_id          := reg.line_id;
     tabTypLinhaIn (1).ordered_quantity := 0;
     tabTypLinhaIn (1).change_reason    := 'Chamado Cancelado';
     tabTypLinhaIn (1).change_comments  := 'CANCEL ORDER';
     tabTypLinhaIn (1).operation        := APPS.oe_globals.g_opr_update;
     APPS.oe_msg_pub.delete_msg;
      
     APPS.OE_ORDER_PUB.process_order (p_api_version_number                      => nmbApiVersao,
                                      p_init_msg_list 						    => APPS.fnd_api.g_false,
                                      p_return_values 						    => APPS.fnd_api.g_false,
                                      p_action_commit 						    => APPS.fnd_api.g_false,
                                      p_line_tbl 						        => tabTypLinhaIn,
                                      x_header_rec  						    => typHeaderOut,
                                      x_header_val_rec 						    => typHeaderValIn,
                                      x_header_adj_tbl  						=> tabtypHeaderAdjOut,
                                      x_header_adj_val_tbl  					=> tabtypHeaderAdjValOut,
                                      x_header_price_att_tbl  			        => tabtypHeaderPriceAttOut,
                                      x_header_adj_att_tbl  					=> tabtypHeaderAdjAttOut,
                                      x_header_adj_assoc_tbl  			        => tabtypAssocAdjOut,
                                      x_header_scredit_tbl 					    => tabtypScreditOut,
                                      x_header_scredit_val_tbl 				    => tabtypScreditValOut,
                                      x_line_tbl  						        => tabTypLinhaOut,
                                      x_line_val_tbl  						    => tabtypLineValOut,
                                      x_line_adj_tbl  						    => tabtypLineAdjOut,
                                      x_line_adj_val_tbl  					    => tabtypLineAdjValOut,
                                      x_line_price_att_tbl  					=> tabtypLinePriceAttOut,
                                      x_line_adj_att_tbl  					    => tabtypLineAdjAttOut,
                                      x_line_adj_assoc_tbl  					=> tabtypLineAdjAssocOut,
                                      x_line_scredit_tbl  					    => tabtypLineScreditOut,
                                      x_line_scredit_val_tbl  				    => tabtypLineScreditValOut,
                                      x_lot_serial_tbl                          => tabtypLotSerialOut,
                                      x_lot_serial_val_tbl                      => tabtypLotSerialValOut,
                                      x_action_request_tbl                      => tabtypActionReqOut,
                                      x_return_status                           => strStatusRetorno,
                                      x_msg_count                               => nmbContador,
                                      x_msg_data                                => strMensagem);

       strMensagem := NULL;
       IF strStatusRetorno <> 'S' THEN
          NULL;
       END IF;
	   COMMIT;
END LOOP;
END putCloseSalesOrder;
/*
#############################################################################
#
# Procedures/Functions Oracle Purchasing
#
#############################################################################
*/  
FUNCTION putCloseRequisition(p_numero_requisicao   IN APPS.PO_REQUISITION_HEADERS_ALL.SEGMENT1%TYPE) RETURN BOOLEAN
AS
 strControleErro                     VARCHAR2 (500);
 nmbContador                         NUMBER := 0;
 CURSOR C_REQUISICAO IS 
     SELECT prh.requisition_header_id,prh.org_id,prl.requisition_line_id,prh.preparer_id,prh.type_lookup_code,
            pdt.document_type_code,prh.authorization_status,prh.closed_code
       FROM apps.po_requisition_headers_all          prh,
            apps.po_requisition_lines_all            prl,
            apps.po_document_types_all               pdt
       WHERE prh.org_id                = APPS.fnd_profile.value('ORG_ID')
         AND pdt.document_type_code    = 'REQUISITION'
         AND prh.authorization_status  = 'APPROVED'
         AND prl.line_location_id      IS NULL
         AND prh.requisition_header_id = prl.requisition_header_id
         AND prh.type_lookup_code      = pdt.document_subtype
         AND prh.org_id                = pdt.org_id
         AND prh.segment1              = p_numero_requisicao;
BEGIN
   FOR reg IN C_REQUISICAO  LOOP
    APPS.po_reqs_control_sv.update_reqs_status(  x_req_header_id        => reg.requisition_header_id
                                          , x_req_line_id          => reg.requisition_line_id
                                          , x_agent_id             => reg.preparer_id
                                          , x_req_doc_type         => reg.document_type_code
                                          , x_req_doc_subtype      => reg.type_lookup_code
                                          , x_req_control_action   => 'FINALLY CLOSE'
                                          , x_req_control_reason   => 'FEECHADA POR API'
                                          , x_req_action_date      => SYSDATE
                                          , x_encumbrance_flag     => 'N'
                                          , x_oe_installed_flag    => 'Y'
                                          , x_req_control_error_rc => strControleErro);   
    nmbContador := nmbContador + 1;
	COMMIT;
   END LOOP;
   RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
      RETURN FALSE;
END putCloseRequisition;
FUNCTION getebusinesspoactions (p_object_id        in number,  
                                p_object_type_code in varchar2,  p_action_code in varchar2 default 'ANY',
                                p_direction in varchar2 default 'NORMAL'/*MAX,MIN*/) RETURN cobratabtyppoactions IS

  colTabTyppoActions       cobratabtyppoActions;
  colTabTyppoActionsAux    cobratabTyppoActions;

BEGIN
    --colTabTyp_poActions.delete;

    select cobraTyppoActions(pah.object_id,
           pah.object_type_code,
           pah.object_sub_type_code,
           pah.sequence_num,
           pah.action_date,
           pah.action_code, 
           pah.employee_id,
           pah.note,
           pah.last_update_date,
           pah.last_updated_by)
      BULK COLLECT INTO colTabTyppoActionsAux      
      FROM apps.po_action_history pah
     where pah.object_id        = p_object_id
       and pah.object_type_code = p_object_type_code
       and pah.action_code      = decode(p_action_code,'ANY', pah.action_code, p_action_code)  
     ;
    -- coltabtyp_poactions.extend;
    --colTabTyp_poActions.extend(coltabtyp_poactionsaux.count);
    if p_direction = 'MIN' then
    --  colTabTyp_poActions.extend(1);
      colTabTyppoActions(1)  := colTabTyppoActionsAux(1);
    elsif p_direction = 'MAX' then
     --- colTabTyp_poActions.extend(1);
      colTabTyppoActions(1)  := colTabTyppoActionsAux(coltabtyppoactionsaux.count);
    elsif p_direction = 'NORMAL' then
      coltabtyppoactions  := coltabtyppoactionsaux;
    end if;
    
  return colTabTyppoActions;
  
exception 
    when others then
      return colTabTyppoActions;
END getebusinesspoactions;

FUNCTION setFuncionarioVendors (p_person_id           IN APPS.PER_ALL_PEOPLE_F.person_id%TYPE) RETURN NUMBER
IS
 CURSOR C_PESSOA IS
   SELECT PAPF.PERSON_ID                           AS PERSON_ID ,
       PAPF.LAST_NAME                              AS NOME, 
       PAPF.EMPLOYEE_NUMBER                        AS MATRICULA, 
       LPAD(BHPD.cpf_number,9,'0')                 AS CPF, 
       LPAD(BHPD.cpf_check_digit,2,'0')            AS DIGITO,
       UE.endereco || ',' || TO_CHAR(UE.nro_end)   AS ENDERECO, 
       UE.bairro                                   AS BAIRRO, 
       UE.cep                                      AS CEP, 
       UE.cidade                                   AS CIDADE, 
       UE.estado                                   AS ESTADO
  FROM PER_ALL_PEOPLE_F                   PAPF,
       PER_ALL_ASSIGNMENTS_F              PAAF,
       BS_HR_PERSON_DATA                  BHPD,
       HR_ALL_ORGANIZATION_UNITS          HAOU,
       RHOWN.UNIORG_ENDERECO@folha        UE
 WHERE UE.cod_uniorg             = SUBSTR(HAOU.NAME,1,5) 
   AND HAOU.organization_id      = PAAF.organization_id
   AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE 
   AND SYSDATE BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE 
   AND SYSDATE BETWEEN BHPD.EFFECTIVE_START_DATE AND BHPD.EFFECTIVE_END_DATE 
   AND PAPF.BUSINESS_GROUP_ID    = HAOU.BUSINESS_GROUP_ID
   AND BHPD.PERSON_ID            = PAPF.PERSON_ID
   AND PAPF.BUSINESS_GROUP_ID    = FND_PROFILE.VALUE('PER_BUSINESS_GROUP_ID')
   AND PAPF.PERSON_ID            = PAAF.PERSON_ID;

   
   consNmbUserId                    CONSTANT NUMBER                                       := FND_PROFILE.VALUE('USER_ID');
   consOrgId                        CONSTANT NUMBER                                       := FND_PROFILE.VALUE('ORG_ID');
   consCharNao                      CONSTANT CHAR(1)                                      := 'N';
   consCharSim                      CONSTANT CHAR(1)                                      := 'Y';
   consVendorType                   CONSTANT PO_VENDORS.VENDOR_TYPE_LOOKUP_CODE%TYPE      := 'EMPLOYEE';
   consTermsId                      CONSTANT PO_VENDORS.TERMS_ID%TYPE                     := 10061;
   consSetOfBooks                   CONSTANT PO_VENDORS.SET_OF_BOOKS_ID%TYPE              := FND_PROFILE.VALUE('GL_SET_OF_BKS_ID');
   consPayDateBasis                 CONSTANT PO_VENDORS.PAY_DATE_BASIS_LOOKUP_CODE%TYPE   := 'DUE';
   consPayGroup                     CONSTANT PO_VENDORS.PAY_GROUP_LOOKUP_CODE%TYPE        := 'Funcionário';
   consPayPriority                  CONSTANT PO_VENDORS.PAYMENT_PRIORITY%TYPE             := 99;
   consPayCurrencCode               CONSTANT PO_VENDORS.PAYMENT_CURRENCY_CODE%TYPE        := 'BRL';
   consPayMethod                    CONSTANT PO_VENDORS.PAYMENT_METHOD_LOOKUP_CODE%TYPE   := 'EFT';
   consTermDateBasis                CONSTANT PO_VENDORS.TERMS_DATE_BASIS%TYPE             := 'Goods Received';
   consEnforceShip                  CONSTANT PO_VENDORS.ENFORCE_SHIP_TO_LOCATION_CODE%TYPE:= 'NONE';
   consReceiptDays                  CONSTANT PO_VENDORS.RECEIPT_DAYS_EXCEPTION_CODE%TYPE  := 'WARNING';
   consReceivingRout                CONSTANT PO_VENDORS.RECEIVING_ROUTING_ID%TYPE         := 2;
   consGlobalAtt09                  CONSTANT PO_VENDORS.GLOBAL_ATTRIBUTE9%TYPE            := 3;   
   consGlobalAtt15                  CONSTANT PO_VENDORS.GLOBAL_ATTRIBUTE15%TYPE           := 'FUNCIONÁRIO';
   consGlobalAttCategory            CONSTANT PO_VENDORS.GLOBAL_ATTRIBUTE_CATEGORY%TYPE    := 'JL.BR.APXVDMVD.VENDORS';
   consBankCharge                   CONSTANT PO_VENDORS.BANK_CHARGE_BEARER%TYPE           := 'I';
   consMatchOption                  CONSTANT PO_VENDORS.MATCH_OPTION%TYPE                 := 'P';
   consDataPadrao                   CONSTANT PO_VENDORS.ATTRIBUTE1%TYPE                   := '01-JAN-99';
   nmbRetorno                       NUMBER := -1;
   nmbQtdade                        NUMBER;
   x_vendor_id                      PO_VENDORS.VENDOR_ID%TYPE;
   x_vendor_site_id		              PO_VENDOR_SITES_ALL.VENDOR_SITE_ID%TYPE;
   strStatus                        VARCHAR2(1000);
   x_exception_msg                  VARCHAR2(4000);
   
BEGIN
 FOR reg IN C_PESSOA LOOP
  BEGIN
   SELECT VENDOR_ID INTO x_vendor_id
     FROM PO_VENDORS 
    WHERE EMPLOYEE_ID = reg.PERSON_ID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        x_vendor_id := -1;
    WHEN OTHERS THEN
        x_vendor_id := 0;
  END;
  IF x_vendor_id = -1 THEN
    ap_po_vendors_apis_pkg.insert_new_vendor	(p_vendor_name                   => reg.nome,
                                               p_vendor_type_lookup_code       => consVendorType,
                                               p_taxpayer_id                   => NULL,
                                               p_tax_registration_id           => NULL,
                                               p_women_owned_flag              => consCharNao,
                                               p_small_business_flag           => NULL,
                                               p_minority_group_lookup_code    => NULL,
                                               p_supplier_number               => reg.matricula,
                                               x_vendor_id                     => x_vendor_id,
                                               x_status                        => strStatus ,
                                               x_exception_msg                 => x_exception_msg,
                                               p_employee_id                   => reg.person_id,
                                               p_source                        => null,
                                               p_what_to_import                => null
                                              );
                                              /*
ap_po_vendors_apis_pkg.insert_new_vendor_site(p_vendor_site_code 		   => v_vendor_site.vendor_site_code,
                                              p_vendor_id 				             => x_vendor_id,
                                              p_org_id 					               => consOrgId,
                                              p_address_line1 			           => reg.ENDERECO,
                                              p_address_line2 		 	           => NULL,
                                              p_address_line3 			           => NULL,
                                              p_address_line4 			           => NULL,
                                              p_city 					                 => reg.CIDADE,
                                              p_state 					               => reg.ESTADO,
                                              p_zip 					                 => reg.CEP,
                                              p_province 				               => NULL,
                                              p_county 					               => v_vendor_site.county,
                                              p_area_code 			               => v_vendor_site.area_code,
                                              p_phone 					               => v_vendor_site.phone,
                                              p_fax_area_code 			           => v_vendor_site.fax_area_code,
                                              p_fax 					                 => v_vendor_site.fax,
                                              p_email_address 			           => NULL,
                                              p_purchasing_site_flag         	 => v_vendor_site.purchasing_site_flag,
                                              p_pay_site_flag 			           => NULL,
                                              p_rfq_only_site_flag 		         => NULL,
                                              x_vendor_site_id				         => x_vendor_site_id,
                                              x_status                         => strStatus ,
                                              x_exception_msg                  => x_exception_msg
											                        );
    */
  END IF;
 END LOOP;  
 RETURN nmbRetorno;
EXCEPTION
  WHEN OTHERS THEN
     RETURN nmbRetorno;
END setFuncionarioVendors;
/*
#############################################################################
#
# Procedures/Functions Oracle Recebimento Integrado
#
#############################################################################
*/ 
FUNCTION getRecLookupValue(p_lookupType IN APPS.REC_LOOKUP_CODES.LOOKUP_TYPE%TYPE,
                           p_lookupCode IN APPS.REC_LOOKUP_CODES.LOOKUP_CODE%TYPE,
                           p_colunas    IN VARCHAR2 DEFAULT 'LOOKUP_CODE,DISPLAYED_FIELD') RETURN VARCHAR2 
IS
strRetorno             VARCHAR2(330)   := p_lookupCode;
strSQL                 VARCHAR2(32767) := 'SELECT ' ||REPLACE(p_colunas,',','|| ''-'' ||') || ' FROM APPS.REC_LOOKUP_CODES WHERE LOOKUP_TYPE = :p_lookupType AND LOOKUP_CODE = :p_lookupCode';
BEGIN
 IF p_lookupCode IS NOT NULL AND p_lookupType IS NOT NULL THEN
    EXECUTE IMMEDIATE strSQL INTO strRetorno USING p_lookupType,p_lookupCode;
 END IF;
 RETURN strRetorno;	 
EXCEPTION
  WHEN OTHERS THEN
     RETURN   strRetorno;
END getRecLookupValue;
/*
#############################################################################
#
# Procedures/Functions Oracle Human Resource, Segurança e Folha de Pagamento
#
#############################################################################
*/ 
FUNCTION getPessoa(p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) RETURN VARCHAR2 AS
  strRetorno                           VARCHAR2(4000):= NULL;
 BEGIN
    SELECT PAPF.EMPLOYEE_NUMBER || '-' || PAPF.LAST_NAME AS NOME  INTO strRetorno
   FROM APPS.PER_ALL_PEOPLE_F  PAPF
  WHERE PAPF.PERSON_ID         = p_person_id
    AND p_effective_date BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE;
 RETURN strRetorno;
 EXCEPTION
   WHEN OTHERS THEN
    RETURN strRetorno;   
 END getPessoa;

 FUNCTION getPessoaAtribuicao(p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE,p_colunas  IN VARCHAR2 DEFAULT 'NOME,MATRICULA,EMAIL,ORGANIZACAO,CARGO,POSICAO,GRADE_NAME,LOCAL,JOB_NAME,PAYROLL,STATUS') RETURN VARCHAR2
AS
 strRetorno                        VARCHAR2(32767):= '--';
 strCampoPadrao                    VARCHAR2(32767):= 'NOME,MATRICULA,EMAIL,ORGANIZACAO,CARGO,POSICAO,GRADE_NAME,LOCAL,JOB_NAME,PAYROLL,STATUS';
 strSQL                            VARCHAR2(32767) := 'SELECT PAPF.LAST_NAME || ''^'' || PAPF.EMPLOYEE_NUMBER || ''^'' || PAPF.EMAIL_ADDRESS || ''^'' ||
                                                      HR_GENERAL.DECODE_ORGANIZATION(PAAF.ORGANIZATION_ID) || ''^'' ||
                                                      PJD.SEGMENT2 || ''^'' ||HR_GENERAL.DECODE_POSITION_LATEST_NAME(PAAF.POSITION_ID)|| ''^'' ||
                                                      HR_GENERAL.DECODE_GRADE(PAAF.GRADE_ID) || ''^'' ||
                                                      HR_GENERAL.DECODE_LOCATION(PAAF.location_id)|| ''^'' ||
                                                      HR_GENERAL.DECODE_JOB(PAAF.JOB_ID)|| ''^'' ||
                                                      HR_GENERAL.DECODE_PAYROLL(PAAF.PAYROLL_ID)|| ''^'' || 
                                                      HR_GENERAL.GET_USER_STATUS(PAAF.ASSIGNMENT_STATUS_TYPE_ID) ' ||
                                        'FROM PER_ALL_PEOPLE_F           PAPF,PER_ALL_ASSIGNMENTS_F      PAAF, ' ||
                                       '     PER_JOBS                     PJ,PER_JOB_DEFINITIONS         PJD, ' ||
     	                                 '     PER_JOBS_TL                PJBT,PAY_PEOPLE_GROUPS           PPG, ' ||
                                       '     PER_GRADE_DEFINITIONS       PGD,PER_GRADES                   PG, ' ||
	                                     '     PER_GRADES_TL              PGDT ' ||
                                       'WHERE PAPF.PERSON_ID        = PAAF.PERSON_ID AND :P_EFFECTIVE_DATE  BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE' ||
                                       ' AND :P_EFFECTIVE_DATE BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE ' ||
                                       ' AND :P_EFFECTIVE_DATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE ' ||
                                       ' AND PAPF.BUSINESS_GROUP_ID     = fnd_profile.VALUE(''PER_BUSINESS_GROUP_ID'')  AND PAAF.PEOPLE_GROUP_ID       = PPG.PEOPLE_GROUP_ID (+) ' ||
                                       ' AND PAAF.JOB_ID                = PJ.JOB_ID (+)  AND PAAF.JOB_ID                = PJBT.JOB_ID (+)  AND PJBT.LANGUAGE           (+)= ''PTB''' || 
                                       ' AND PJ.JOB_DEFINITION_ID       = PJD.JOB_DEFINITION_ID (+) AND PAAF.GRADE_ID              = PG.GRADE_ID (+) ' ||
                                       ' AND PAAF.GRADE_ID              = PGDT.GRADE_ID (+)  AND PGDT.LANGUAGE          (+) = ''PTB''' ||
                                       ' AND PG.GRADE_DEFINITION_ID     = PGD.GRADE_DEFINITION_ID (+) AND PAPF.PERSON_ID = :P_PERSON_ID';

BEGIN
  IF p_effective_date  IS NOT NULL AND p_person_id  IS NOT NULL AND p_colunas IS NOT NULL THEN
    EXECUTE IMMEDIATE strSQL INTO strRetorno USING p_effective_date,p_effective_date,p_effective_date,p_person_id;
  END IF;
 RETURN strRetorno;
EXCEPTION
  WHEN OTHERS THEN
     --RAISE_APPLICATION_ERROR (-20001,'COM ' || SQLERRM || ' E COM O SQLCODE ' || SQLCODE || ' ==> ' || p_person_id);
     RETURN strRetorno;
END getPessoaAtribuicao;
FUNCTION getPessoaLogin     (p_effective_date      IN DATE,p_user_id    IN APPS.FND_USER.USER_ID%TYPE) RETURN VARCHAR2
AS  
 strRetorno                 VARCHAR2(32767);
 CURSOR CP_LOGIN_PESSOA (pi_effective_date      IN DATE,pi_user_id   IN APPS.FND_USER.USER_ID%TYPE) IS
    SELECT fu.user_name || '-' || PAPF.LAST_NAME AS VALOR
  FROM APPS.FND_USER                  FU,
       APPS.PER_ALL_PEOPLE_F          PAPF
 WHERE PAPF.PERSON_ID              = FU.EMPLOYEE_ID
   AND pi_effective_date BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
   AND FU.USER_ID                  = P_USER_ID;
BEGIN
  FOR reg IN CP_LOGIN_PESSOA (pi_effective_date   => p_effective_date,pi_user_id  => p_user_id ) LOOP
      strRetorno  := reg.valor;
  END LOOP;
  RETURN strRetorno;
END getPessoaLogin;
FUNCTION getUserPersonType(p_effective_date      IN DATE,p_person_id                    IN     APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) RETURN VARCHAR2
IS
  CURSOR cp_person_types(p_effective_date      IN DATE,p_person_id                    IN     APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) IS
    SELECT ttl.user_person_type
      FROM apps.per_person_types_tl       ttl,
           apps.per_person_types          typ,
           apps.per_person_type_usages_f  ptu
     WHERE ttl.language          = userenv('LANG')
       AND ttl.person_type_id    = typ.person_type_id
       AND typ.system_person_type IN ('APL','EMP','EX_APL','EX_EMP','CWK','EX_CWK','OTHER')
       AND typ.person_type_id    = ptu.person_type_id
       AND p_effective_date BETWEEN ptu.effective_start_date AND ptu.effective_end_date
       AND ptu.person_id = p_person_id
  ORDER BY DECODE(typ.system_person_type
                 ,'EMP'   ,1
                 ,'CWK'   ,2
                 ,'APL'   ,3
                 ,'EX_EMP',4
                 ,'EX_CWK',5
                 ,'EX_APL',6
                          ,7
                 );
  strUserPersonType             VARCHAR2(4000);
BEGIN
  FOR regPersonType IN cp_person_types(p_effective_date=> p_effective_date,p_person_id=> p_person_id) LOOP
      strUserPersonType := regPersonType.user_person_type;
  END LOOP;
  RETURN strUserPersonType;
END getUserPersonType;
FUNCTION getPessoaSeg  (p_effective_date      IN DATE,p_matricula    IN VARCHAR2) RETURN VARCHAR2 AS
 strRetorno                           VARCHAR2(4000):= NULL;
  FUNCTION getLoginSeg (p_matricula IN VARCHAR2) RETURN VARCHAR2 IS
 strRetLogin            VARCHAR2(4000):= '';
BEGIN
  SELECT RESERVA   INTO strRetLogin
    FROM COBGATE.si_adm_colaboradores_t
   WHERE NVL(us_logon_criado,'N') = 'S'
     AND NVL(us_logon_tp,0)       = 0
     AND MAtricula                = p_matricula;
  RETURN strRetLogin;
EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20001,'==> ' || sqlerrm);
     RETURN strRetLogin;
END getLoginSeg;
FUNCTION getEmailSeg (p_matricula IN VARCHAR2) RETURN VARCHAR2 IS
 strRetEmail            VARCHAR2(4000):= '';
BEGIN
  SELECT DECODE (NVL(RESERVA,'-1'),'-1',NULL,RESERVA|| '@cobra.com.br') INTO strRetEmail
    FROM COBGATE.si_adm_colaboradores_t
   WHERE NVL(us_logon_criado,'N') = 'S'
     AND NVL(us_logon_tp,0)       = 0
     AND MAtricula                = p_matricula;
  RETURN strRetEmail;
EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20001,'==> ' || sqlerrm);
     RETURN strRetEmail;
END getEmailSeg;
 BEGIN
  IF p_matricula IS NOT NULL THEN
     strRetorno := upper(getEmailSeg (p_matricula) || '^' || getLoginSeg (p_matricula));
  END IF;
 RETURN strRetorno;
 EXCEPTION
   WHEN OTHERS THEN
    RETURN strRetorno;   
 END getPessoaSeg;

FUNCTION getPessoaTelefone(p_effective_date      IN DATE,p_person_id    IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE, p_tipo IN NUMBER DEFAULT 1) RETURN typarrayvarchar 
IS
tabtyparrayvarchar                  typarrayvarchar := typarrayvarchar();
strRetorno                          VARCHAR2(32767);
CURSOR cp_person_phones (p_effective_date      IN DATE,p_person_id                    IN     APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) IS
  SELECT getLookupValue('PHONE_TYPE',PP.PHONE_TYPE) AS TIPO,
         PP.PHONE_NUMBER NUMERO
    FROM APPS.PER_PHONES            PP
   WHERE p_effective_date BETWEEN NVL(PP.DATE_FROM,p_effective_date-1) AND NVL(DATE_TO,TO_DATE('31/12/4712','DD/MM/YYYY'))
     AND PP.PARENT_TABLE                 = 'PER_ALL_PEOPLE_F' 
     AND PP.PARENT_ID                    =  p_person_id;
BEGIN
   FOR regPersonPhone IN cp_person_phones(p_effective_date=> p_effective_date,p_person_id=> p_person_id) LOOP
      tabtyparrayvarchar.extend;
      tabtyparrayvarchar( tabtyparrayvarchar.count ) := regPersonPhone.tipo || '^' || regPersonPhone.numero;
   END LOOP;
   IF p_tipo = 2  THEN
      strRetorno := COBRA_UTILITY.getArrayToString(tabtyparrayvarchar,'^');
      tabtyparrayvarchar.DELETE;
      tabtyparrayvarchar.extend;
      tabtyparrayvarchar( tabtyparrayvarchar.count ) := strRetorno;
   END IF;
  RETURN tabtyparrayvarchar;
END getPessoaTelefone;

FUNCTION geteBusinessHierOrg(p_person_id IN number) RETURN cobratABTypHierOrg  IS
  Bgid               Number:= APPS.fnd_profile.value('PER_BUSINESS_GROUP_ID');   
  COLTABTYP_HAOU    cobratABTypHierOrg;
  Numpersonid       Number:=0;  
  strOrgName        Hr_All_Organization_Units.name%type;
  
  BEGIN
     COLTABTYP_HAOU.DELETE; 
     numPersonId   := p_person_id;
     begin         
          select substr(trim(cobra_utility.getpiece(haou.name, '-', 1)), 6, 5)  Into Strorgname
            From Hr_All_Organization_Units Haou 
              ,Per_All_Assignments_F Paaf
              ,Per_All_people_F Papf
           Where Paaf.Organization_Id = Haou.Organization_Id  
             and paaf.person_id       = papf.person_id
             And Papf.person_id       = Numpersonid
             And Sysdate Between Paaf.Effective_Start_Date And Paaf.Effective_End_Date
             And SYSDATE between Papf.effective_start_date AND Papf.effective_end_date;
          select cobraTypHierOrg (
                0 
                ,Ch.Scr
                ,'' 
                ,'' 
                ,'' 
                ,SYSDATE
                ,SYSDATE
                

                ,paaf.organization_id
                ,paaf.location_id
                ,Ch.Orgname
              
                ,ch.gestor_employee
                ,paaf.person_id     
                ,Paaf.Supervisor_Id 
                ,paaf.position_id
                
                ,''
                ,'' 
                ,'' 
                ,'' )
                BULK COLLECT INTO colTabTYP_HAOU   
            from (
                    Select Pose.Organization_Id_Parent, 
                           Pose.Organization_Id_Child,
                           Haou.Name       OrgName, 
                           Haou.Attribute1 Gestor_Employee,
                           Haou.attribute7 SCR
                        From  Per_Org_Structure_Elements Pose
                              ,hr_all_organization_units  haou
                              --,per_all_assignments_f      paaf
                              
                        where  pose.organization_id_child = haou.organization_id
                          -- And  Pose.Organization_Id_Child = Paaf.Organization_Id
                          -- And  Haou.Organization_Id = Paaf.Organization_Id
                          -- And  Sysdate Between Paaf.Effective_Start_Date And Paaf.Effective_End_Date
			  and pose.org_structure_version_id = ( SELECT org_structure_version_id 
                                                                  from per_org_structures_lov
                                                                 where primary_structure_flag = 'Y'                                
                                                                )
                      Group By Pose.Organization_Id_Parent, Pose.Organization_Id_Child,  Haou.Attribute1, Haou.Attribute7, Haou.Name
           ) ch 
             , per_all_people_f papf
             , per_all_assignments_f paaf
            where papf.employee_number (+)= ch.gestor_employee
              and paaf.person_id (+)= papf.person_id 
               and SYSDATE between nvl(papf.effective_start_date,SYSDATE-1) and nvl(papf.effective_end_date,SYSDATE+1)
               and SYSDATE between nvl(paaf.effective_start_date,SYSDATE-1) and nvl(paaf.effective_end_date,SYSDATE+1)
              --- start with ch.orgname = strorgname  ---- '1010108020 - GERENCIA DE SUPORTE INTERNO'
              start with substr(trim(cobra_utility.getpiece(ch.orgname, '-', 1)), 6, 5) like '%' || strorgname || '%'
              CONNECT BY NOCYCLE
              PRIOR ch.organization_id_child = ch.organization_id_parent 
            group by   ch.scr
                ,paaf.organization_id
                ,paaf.location_id
                ,Ch.Orgname              
                ,ch.gestor_employee
                ,paaf.person_id    
                ,paaf.supervisor_id 
                ,paaf.position_id
           ;
      END; 
      IF COLTABTYP_HAOU.COUNT > 0 THEN
          FOR REGINC IN COLTABTYP_HAOU.FIRST..COLTABTYP_HAOU.LAST LOOP
              Begin
                  BEGIN
                        Select B.Flex_Value_Id,B.Attribute3    Scr_Sigla,T.Description   Scr_Descricao,               B.ENABLED_FLAG  SCR_ATIVO, B.START_DATE_ACTIVE START_DATE,  B.End_Date_Active   End_Date
                          INTO Coltabtyp_Haou(Reginc).Flex_Value_Id, Coltabtyp_Haou(Reginc).Scr_Sigla, Coltabtyp_Haou(Reginc).Scr_Descricao                             , Coltabtyp_Haou(Reginc).SCR_Ativo, Coltabtyp_Haou(Reginc).Scr_Start_Date , Coltabtyp_Haou(Reginc).Scr_End_Date
                          From Applsys.Fnd_Flex_Values_Tl T,  --- Fnd_Flex_Values_Tl T, -- Applsys.Fnd_Flex_Values_Tl T, 
                               FND_FLEX_VALUES B 
                          Where  
                            B.FLEX_VALUE_ID         = T.FLEX_VALUE_ID
                            AND B.VALUE_CATEGORY    = 'COB_GL_CENTRO'
                            AND B.FLEX_VALUE_SET_ID = 1003450
                            And T.Language          = 'PTB' -- userenv('LANG')
                            AND B.FLEX_VALUE        = COLTABTYP_HAOU(REGINC).SCR
                         ;
                    Exception
                      When Others Then
                        Null;
                    END;    
         
                     BEGIN /*Busca informações referente a Posção do GESTOR da Organizacao*/
                         
                          Select Pp.Name 
                              , Pp.Attribute1 Nivel_Posicao 
                              , Pp.Attribute3 Cargo 
                              , CASE WHEN PP.NAME LIKE '%|CAT%' THEN 'Y' ELSE 'N' END CAT 
                            Into Coltabtyp_Haou(Reginc).Pos_Name 
                              , Coltabtyp_Haou(Reginc).Nivel_Posicao
                              , Coltabtyp_Haou(Reginc).Cargo 
                              , COLTABTYP_HAOU(REGINC).CAT
                            FROM 
                              PER_POSITIONS PP
                           WHERE PP.BUSINESS_GROUP_ID = BGID --- 21 
                             AND PP.POSITION_ID   = COLTABTYP_HAOU(REGINC).POS_ID  -- 1394155
                          ;
              
                      EXCEPTION
                        WHEN OTHERS THEN              
                          NULL;              
                      END; --- FIM Busca Posicao
                      
              EXCEPTION
                WHEN OTHERS THEN 
                      -- Se não encotrar os dados no HR, não preenchelos
                      NULL;
              END; --- FIM Busca Organizacao
              
          END LOOP; --- Fim do Loop do collenctio
      
      END IF; --- Fim do count Collection  

      return COLTABTYP_HAOU;

  Exception 
    When Others Then
      FND_FILE.put_line( FND_FILE.LOG,substr(sqlerrm,1,200));
      return COLTABTYP_HAOU;

END geteBusinessHierOrg;
FUNCTION getQtdadeLotacao   (p_effective_date      IN DATE,p_local        IN VARCHAR2,p_cargo IN VARCHAR2) RETURN NUMBER
AS
 nmbRetornaQuantidade          NUMBER;
BEGIN
/* 
 CURSOR C_QUANTIDADE_LOTACAO IS
   SELECT COUNT(*) AS QTDADE
  FROM PER_ALL_PEOPLE_F            PAPF,
       PER_ALL_ASSIGNMENTS_F       PAAF,
       HR_ALL_ORGANIZATION_UNITS   HAOU,
       PER_ROLES                   PRLE,
       PER_JOBS                    PRJB, 
       PER_JOBS                    PRFN
 WHERE p_effective_date BETWEEN NVL(PRFN.DATE_FROM,SYSDATE-1) AND NVL(PRFN.DATE_TO,SYSDATE + 1)
   AND PRFN.JOB_ID      (+)    = PAAF.JOB_ID
   AND p_effective_date BETWEEN NVL(PRJB.DATE_FROM,SYSDATE-1) AND NVL(PRJB.DATE_TO,SYSDATE + 1)
   AND PRJB.JOB_ID      (+)    = PRLE.JOB_ID
   AND p_effective_date BETWEEN NVL(PRLE.START_DATE,SYSDATE-1) AND NVL(PRLE.END_DATE,SYSDATE + 1)
   AND PRLE.PERSON_ID   (+)     = PAPF.PERSON_ID 
   AND HAOU.ORGANIZATION_ID  = PAAF.ORGANIZATION_ID
   AND p_effective_date BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE
   AND p_effective_date BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
   AND PAAF.PRIMARY_FLAG     = 'Y'
   AND PAAF.PERSON_ID        = PAPF.PERSON_ID
   AND SUBSTR(TRIM(COBRA_UTILITY.GETPIECE(HAOU.NAME,'-',1)),-5) = p_local
   AND UPPER(COBRA_UTILITY.GETPIECE(nvl(PRJB.NAME,PRFN.NAME),'|',2))   = UPPER(p_cargo);
BEGIN
  nmbRetornaQuantidade := 0;
  FOR reg IN C_QUANTIDADE_LOTACAO LOOP
     nmbRetornaQuantidade := REG.QTDADE;
  END LOOP;
*/
  SELECT QTDADE INTO nmbRetornaQuantidade 
    FROM COBRA_LOTACAO 
   WHERE LOCAL    =  p_local 
     AND CARGO    =  UPPER(p_cargo);
  RETURN nmbRetornaQuantidade;
EXCEPTION
  WHEN OTHERS THEN
      RETURN 0;
END getQtdadeLotacao;
/*
#############################################################################
#
# Procedures/Functions Oracle Foundation
#
#############################################################################
*/ 
PROCEDURE expiraPassword AS
 bolRetorno             BOOLEAN;
BEGIN
  bolRetorno := APPS.FND_PROFILE.SAVE(X_NAME => 'SIGNON_PASSWORD_HARD_TO_GUESS', X_VALUE=> 'Yes', X_LEVEL_NAME => 'SITE');
  
  bolRetorno := APPS.FND_PROFILE.SAVE(X_NAME => 'SIGNON_PASSWORD_NO_REUSE'     , X_VALUE=> '180', X_LEVEL_NAME => 'SITE');
  
  bolRetorno := APPS.FND_PROFILE.SAVE(X_NAME => 'COBRA:VALIDADE_PASSWORD'      , X_VALUE=> '90' , X_LEVEL_NAME => 'SITE');
  
  UPDATE apps.FND_USER SET PASSWORD_DATE = NULL WHERE user_id >= 1110;
  COMMIT;
END expiraPassword;
PROCEDURE InicializaDebub
IS
  nmbRequestId  NUMBER;
  strDiretorio  VARCHAR2(200);
  strArquivo    VARCHAR2(200);
  strDirArquivo VARCHAR2(200);
BEGIN
/*
  IF (g_print_debug) THEN
    COBRA_DEBUG_FLAG := 'YES';
  END IF;
  COBRA_DEBUG_TABLE.DELETE;
  COBRA_DEBUG_COUNT      := 0;
  COBRA_DEBUG_INDEX      := 0;
  IF cobra_debug_flag    <> 'YES' THEN
    cobra_debug_file     := 'NO';
  ELSIF cobra_debug_flag <> 'YES' THEN
    strDirArquivo        := 'HORACIO';
    IF strDirArquivo     IS NOT NULL THEN
      nmbRequestId       := fnd_global.conc_request_id;
      IF nmbRequestId    IS NULL OR nmbRequestId <= 0 THEN
        strDiretorio     := SUBSTR(strDirArquivo, 1, instr(strDirArquivo, ' ')-1);
        strArquivo       := SUBSTR(strDirArquivo, instr(strDirArquivo, ' ')   +1);
        IF strDiretorio  IS NOT NULL AND strArquivo IS NOT NULL THEN
          fnd_file.put_names(strArquivo||'.log', strArquivo||'.out', strDiretorio);
        END IF;
      END IF;
      cobra_debug_file := 'YES';
      FND_FILE.PUT_LINE(FND_FILE.LOG, 'Iniciando depuração de sessão....');
    END IF;
  END IF;
*/
NULL;
END InicializaDebub;
PROCEDURE sincSegurancaHReFolha  AS
  nmbUserId                        NUMBER:= FND_PROFILE.VALUE('COBRA:USUARIO_INTERFACE');
  nmbConta                         NUMBER;
  nmbRespId                        NUMBER:= 50112;
  nmbApplication                   NUMBER:= 800;
  strMatricula                     PER_ALL_PEOPLE_F.EMPLOYEE_NUMBER%TYPE;
  nmbPersonId                      PER_ALL_PEOPLE_F.PERSON_ID      %TYPE;
  strRegistro                      VARCHAR2(32767);
  streMail                         VARCHAR2(4000);
  strLogin                         VARCHAR2(4000);
  datProcessamento                 DATE:= SYSDATE;
  datPer_effective_start_date 	   DATE;
  datPer_effective_end_date 	     DATE;
  bolName_combination_warning			 BOOLEAN;
  bolAssign_payroll_warning        BOOLEAN;
  bolOrig_hire_warning             BOOLEAN;
  strFull_name                     APPS.PER_ALL_PEOPLE_F.FULL_NAME%TYPE;
  nmbCommentId                     NUMBER;
  CURSOR CP_USUARIO (P_PERSON_ID IN APPS.PER_ALL_PEOPLE_F.PERSON_ID%TYPE) IS 
    SELECT USER_ID, USER_NAME,ENCRYPTED_FOUNDATION_PASSWORD,ENCRYPTED_USER_PASSWORD,START_DATE, EMPLOYEE_ID, EMAIL_ADDRESS, PERSON_PARTY_ID
      FROM FND_USER 
     WHERE EMPLOYEE_ID   = P_PERSON_ID;

  CURSOR C_PESSOAL IS
    SELECT PAPF.PERSON_ID,PAPF.EMPLOYEE_NUMBER, PAPF.object_version_number,
           PAPF.EFFECTIVE_START_DATE,PAPF.EFFECTIVE_END_DATE,PAPF.FULL_NAME, PAPF.PARTY_ID, TO_CHAR(PAPF.DATE_OF_BIRTH,'DDMMYYYY') SENHA
          FROM APPS.PER_PERSON_TYPE_USAGES_F      PPTUF,
               APPS.PER_ALL_PEOPLE_F              PAPF,
               APPS.PER_PERSON_TYPES              PPT
         WHERE SYSDATE BETWEEN PPTUF.EFFECTIVE_START_DATE AND PPTUF.EFFECTIVE_END_DATE
           AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
           AND PPT.SYSTEM_PERSON_TYPE    = 'EMP'
           AND PAPF.BUSINESS_GROUP_ID    = APPS.FND_PROFILE.VALUE('PER_BUSINESS_GROUP_ID')
           AND PPT.BUSINESS_GROUP_ID     = PAPF.BUSINESS_GROUP_ID
           AND PPT.PERSON_TYPE_ID        = PPTUF.PERSON_TYPE_ID
           AND PAPF.PERSON_ID            = PPTUF.PERSON_ID
           --and PAPF.EMPLOYEE_NUMBER IN ('106849','107888','107415','107761','103494')
           ;
BEGIN
    FND_GLOBAL.APPS_INITIALIZE(nmbUserId,nmbRespId,  nmbApplication);
    FOR reg IN C_PESSOAL LOOP
      strRegistro := cobra_utility_ebs.getPessoaSeg(sysdate,reg.EMPLOYEE_NUMBER);
      streMail    := cobra_utility.getPiece(strRegistro,'^',1);
      strLogin    := cobra_utility.getPiece(strRegistro,'^',2);
      
	  BEGIN
       IF streMail IS NOT NULL THEN
             /*	   
             hr_person_api.update_person(p_validate                     		 => FALSE
				                                ,p_effective_date               		 => SYSDATE
				                                ,p_datetrack_update_mode             => 'CORRECTION'
				                                ,p_person_id                         => reg.person_id
                                        ,p_object_version_number             => reg.object_version_number
	                                      ,p_employee_number                   => reg.EMPLOYEE_NUMBER
                                        ,p_email_address                     => streMail
					                              ,p_effective_start_date              => datPer_effective_start_date
                                        ,p_effective_end_date                => datPer_effective_end_date
  				                              ,p_full_name                         => strFull_name 
					                              ,p_comment_id                        => nmbCommentId 
					                              ,p_name_combination_warning          => bolName_combination_warning	
					                              ,p_assign_payroll_warning            => bolAssign_payroll_warning
					                              ,p_orig_hire_warning                 => bolOrig_hire_warning
					                              );
              FOR regUser IN CP_USUARIO (P_PERSON_ID => reg.person_id) LOOP
                  FND_USER_PKG.UpdateUser ( x_user_name             => regUser.user_name,
                                            x_owner                 => 'CUST',
                                            x_email_address         => streMail
                                          );
              END LOOP;
			  */
			  NULL;
        END IF;
      EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,'PROBLEMA EM - HR_EMPLOYEE_API.create_employee - COM  '||SQLCODE||' <----> '|| SQLERRM);
      END;
      BEGIN                                                
      UPDATE COBGATE.funcionario_complemento
         SET IDENTIFICACAO_USUARIO = strLogin, E_MAIL = streMail  WHERE ID_FUNCIONARIO = REG.EMPLOYEE_NUMBER;
     EXCEPTION
        WHEN  OTHERS THEN
            --FND_FILE.put_line( FND_FILE.LOG,'Apenas atualizamos a tabela de funcionario_complemento.');
            null;
     END;
     SELECT COUNT(*) INTO nmbConta 
       FROM COBGATE.funcionario_senha 
      WHERE ID_FUNCIONARIO = REG.EMPLOYEE_NUMBER;
      --FND_FILE.put_line( FND_FILE.LOG,'== Atualizando COBGATE.funcionario_senha  ' || nmbConta);
      IF nmbConta = 0 THEN
          BEGIN
             INSERT INTO COBGATE.funcionario_senha (ID_FUNCIONARIO,SENHA,DATA_REGISTRO,USUARIO_ORACLE,SENHA_ORACLE,STRING_ORACLE,DATA_FIM_VIGENCIA,OBS) VALUES
                                                   (REG.EMPLOYEE_NUMBER,REG.SENHA,datProcessamento,'RHOWN',NULL,NULL,NULL,NULL);
          EXCEPTION
             WHEN OTHERS THEN
                 --FND_FILE.put_line( FND_FILE.LOG,'Problema em COBGATE.funcionario_senha  '||SQLCODE||' <----> '|| SQLERRM);
                 null;
          END;
      END IF;

      SELECT COUNT(*) INTO nmbConta 
        FROM COBGATE.FUNCIONARIO_PERFIS
       WHERE ID_FUNCIONARIO = REG.EMPLOYEE_NUMBER;
      --FND_FILE.put_line( FND_FILE.LOG,'== Atualizando COBGATE.FUNCIONARIO_PERFIS  ' || nmbConta);
       IF nmbConta = 0 THEN
         BEGIN
           INSERT INTO COBGATE.FUNCIONARIO_PERFIS(ID_FUNCIONARIO,CODIGO_PERFIL,INCIO_VALIDADE,TERMINO_VALIDADE) VALUES
                                                 (REG.EMPLOYEE_NUMBER,'PORTAL_01P',datProcessamento,null);
         EXCEPTION
           WHEN OTHERS THEN
               --FND_FILE.put_line( FND_FILE.LOG,'COBGATE.FUNCIONARIO_PERFIS  '||SQLCODE||' <----> '|| SQLERRM);
               null;
         END;
       END IF;

      COMMIT;
  END LOOP;
END sincSegurancaHReFolha;
PROCEDURE putEscrevenoLogConcurrent(p_strBuffer IN VARCHAR2) AS
BEGIN
  FND_FILE.PUT_LINE(FND_FILE.LOG,p_strBuffer);
  fnd_file.new_line(FND_FILE.LOG,1);
EXCEPTION
WHEN OTHERS THEN
  RETURN;
END putEscrevenoLogConcurrent;
PROCEDURE putEscrevenoOutConcurrent(p_strBuffer IN VARCHAR2) AS
BEGIN
  FND_FILE.PUT_LINE(FND_FILE.OUTPUT , p_strBuffer);
  fnd_file.new_line(FND_FILE.OUTPUT,1);
EXCEPTION
WHEN OTHERS THEN
  RETURN;
END putEscrevenoOutConcurrent;
FUNCTION isPeriodosFechados(p_periodo IN VARCHAR2) RETURN BOOLEAN AS 
 bolRetorno                       BOOLEAN:= FALSE;
 CURSOR CP_APLICACOES (P_PERIODO IN VARCHAR2) IS
    SELECT FA.APPLICATION_NAME                AS APLICACAO, 
           MP.ORGANIZATION_CODE               AS ORGANIZACAO,
           GPS.PERIOD_SET_NAME                AS CALENDARIO, 
           GPS.DESCRIPTION                    AS DESCRICAO_CALENDARIO,
           GP.PERIOD_NAME                     AS PERIODO,
           GP.START_DATE                      AS DATA_INICIAL,
           GP.END_DATE                        AS DATA_TERMINO,
           FSP.SET_OF_BOOKS_ID                AS SET_OF_BOOK, 
           NVL (FSP.REQ_ENCUMBRANCE_FLAG,'N') AS ENCUMBRANCE_FLAG, 
           FSP.INVENTORY_ORGANIZATION_ID      AS ORGANIZACAO_MESTRE, 
           GPSA.closing_status                AS STATUS
      FROM APPS.GL_PERIOD_SETS                   GPS,
           APPS.GL_PERIODS                       GP,
           APPS.FINANCIALS_SYSTEM_PARAMS_ALL     FSP,
           APPS.FND_APPLICATION_VL                FA,
           APPS.GL_PERIOD_STATUSES               GPSA,
           APPS.ORG_ACCT_PERIODS                 OAP,
           APPS.MTL_PARAMETERS                   MP
     WHERE GP.PERIOD_SET_NAME    = GPS.PERIOD_SET_NAME
       AND GPSA.SET_OF_BOOKS_ID  = FSP.SET_OF_BOOKS_ID
       AND GPSA.APPLICATION_ID   = FA.APPLICATION_ID
       AND GPSA.PERIOD_NAME      = GP.PERIOD_NAME
       AND OAP.PERIOD_NAME       = GPSA.PERIOD_NAME
       AND OAP.PERIOD_SET_NAME   = GPS.PERIOD_SET_NAME
       AND MP.ORGANIZATION_ID    = OAP.ORGANIZATION_ID
       AND GPSA.PERIOD_NAME      = P_PERIODO
       AND GPSA.closing_status   <> 'O'
ORDER BY FA.APPLICATION_NAME, GP.START_DATE;    
BEGIN
    FOR regPeriodos IN CP_APLICACOES (P_PERIODO => p_periodo) LOOP
        bolRetorno := true;
    END LOOP;
    RETURN bolRetorno;
END isPeriodosFechados;
FUNCTION getLookupValue(p_lookupType IN APPS.FND_LOOKUP_VALUES.LOOKUP_TYPE%TYPE,
                        p_lookupCode IN APPS.FND_LOOKUP_VALUES.LOOKUP_CODE%TYPE,
                        p_colunas    IN VARCHAR2 DEFAULT 'LOOKUP_CODE,MEANING') RETURN VARCHAR2 
IS
strRetorno                           VARCHAR2(330):= p_lookupCode;
strSQL                               VARCHAR2(32767):= 'SELECT ' ||REPLACE(p_colunas,',','|| ''-'' ||') || ' FROM APPS.FND_LOOKUP_VALUES WHERE LOOKUP_TYPE = :p_lookupType AND LOOKUP_CODE = :p_lookupCode  AND LANGUAGE = USERENV(''LANG'')';
BEGIN
 IF p_lookupCode IS NOT NULL AND p_lookupType IS NOT NULL THEN
    EXECUTE IMMEDIATE strSQL INTO strRetorno USING p_lookupType,p_lookupCode;
 END IF;
 RETURN strRetorno;	 
EXCEPTION
  WHEN OTHERS THEN
     RETURN   strRetorno;
END getLookupValue;

FUNCTION getFlexValue(p_flex_value_set_id      IN APPS.FND_FLEX_VALUES.FLEX_VALUE_SET_ID%TYPE,
                      p_flex_value             IN APPS.FND_FLEX_VALUES.FLEX_VALUE       %TYPE,
                      p_colunas    IN VARCHAR2 DEFAULT 'A.flex_value,B.description') RETURN VARCHAR2 
IS                      
strRetorno            VARCHAR2(4000)   := p_flex_value;
strSQL                 VARCHAR2(32767) := 'SELECT '||REPLACE(p_colunas,',','|| ''-'' ||') || '  FROM APPS.FND_FLEX_VALUES FFV,APPS.FND_FLEX_VALUES_TL   FFVT WHERE FLEX_VALUE_SET_ID   = :p_flex_value_set_id AND A.flex_value_id   = B.flex_value_id  AND B.LANGUAGE = USERENV(''LANG'') AND A.flex_value  = :p_flex_value';

BEGIN
 IF p_flex_value_set_id IS NOT NULL AND p_flex_value  IS NOT NULL THEN
    EXECUTE IMMEDIATE strSQL INTO strRetorno USING p_flex_value_set_id,p_flex_value;
 END IF;
 RETURN strRetorno;
 EXCEPTION
   WHEN OTHERS THEN
    RETURN strRetorno;   
END getFlexValue;

FUNCTION getConcParameter   (p_requestid           IN APPS.FND_CONCURRENT_REQUESTS.REQUEST_ID%TYPE) RETURN typarrayvarchar
AS
   tabRetorno          typarrayvarchar:= typarrayvarchar();
BEGIN
  -- TO_CHAR(SEQ) || - || PROMPT || ': ' || COBRA_UTILITY.GETPIECE(ARGUMENTO,',',ROWNUM)
  SELECT PROMPT || ': ' || COBRA_UTILITY.GETPIECE(ARGUMENTO,',',ROWNUM) BULK COLLECT INTO tabRetorno
    FROM (SELECT FDFCUV.COLUMN_SEQ_NUM    SEQ,FDFCUV.FORM_LEFT_PROMPT  PROMPT,FCR.ARGUMENT_TEXT        ARGUMENTO
            FROM APPS.FND_CONCURRENT_REQUESTS            FCR,
                 APPS.FND_CONCURRENT_PROGRAMS            FCP,
                 APPS.FND_DESCR_FLEX_COL_USAGE_VL        FDFCUV
           WHERE FCR.REQUEST_ID                    = p_requestId
             AND FCP.APPLICATION_ID                = FCR.PROGRAM_APPLICATION_ID
             AND FCP.CONCURRENT_PROGRAM_ID         = FCR.CONCURRENT_PROGRAM_ID
             AND FDFCUV.DESCRIPTIVE_FLEXFIELD_NAME = '$SRS$.'|| FCP.CONCURRENT_PROGRAM_NAME
        ORDER BY 1,2);
   RETURN tabRetorno;               
END getConcParameter;

FUNCTION iseBusinessLogin(p_username IN varchar2,  p_password IN varchar2) RETURN BOOLEAN AS 
 bolRetorno             BOOLEAN;
 BEGIN 
   bolRetorno := APPS.FND_USER_PKG.ValidateLogin(p_username,p_password);
   RETURN bolRetorno;
END iseBusinessLogin;

FUNCTION setUserResponsibility (p_user_name           IN APPS.FND_USER.USER_NAME%TYPE,
                                p_responsibility_name IN APPS.FND_RESPONSIBILITY_VL.RESPONSIBILITY_NAME%TYPE ) RETURN BOOLEAN AS
strRespKey 					VARCHAR2(30);
strAppShortName 			VARCHAR2(50);
BEGIN
  SELECT r.responsibility_key ,a.application_short_name INTO strRespKey,strAppShortName
    FROM APPS.fnd_responsibility_vl     r,
         APPS.fnd_application_vl        a
   WHERE r.application_id     =   a.application_id
     AND UPPER(r.responsibility_name) = UPPER(p_responsibility_name);

 APPS.FND_USER_PKG.ADDRESP ( username       => p_user_name,
                             resp_app       => strAppShortName,
                             resp_key       => strRespKey,
                             security_group => 'STANDARD',
                             description    => NULL,
                             start_date     => sysdate,
                             end_date       => null
                            );
  COMMIT;
EXCEPTION
 WHEN OTHERS THEN
      ROLLBACK;
END setUserResponsibility;
FUNCTION getRequesteBusiness   ( p_application IN varchar2 default NULL,			  
                                 p_program     IN varchar2 default NULL,
			                     p_description IN varchar2 default NULL,	      p_start_time  IN varchar2 default NULL,
                                 p_sub_request IN boolean  default FALSE,		  p_argument1   IN varchar2 default CHR(0),
                                 p_argument2   IN varchar2 default CHR(0),		  p_argument3   IN varchar2 default CHR(0),
                                 p_argument4   IN varchar2 default CHR(0),		  p_argument5   IN varchar2 default CHR(0),
                                 p_argument6   IN varchar2 default CHR(0),		  p_argument7   IN varchar2 default CHR(0),
                                 p_argument8   IN varchar2 default CHR(0),		  p_argument9   IN varchar2 default CHR(0),
                                 p_argument10  IN varchar2 default CHR(0),		  p_argument11  IN varchar2 default CHR(0),
                                 p_argument12  IN varchar2 default CHR(0),		  p_argument13  IN varchar2 default CHR(0),
                                 p_argument14  IN varchar2 default CHR(0),		  p_argument15  IN varchar2 default CHR(0),
                                 p_argument16  IN varchar2 default CHR(0),		  p_argument17  IN varchar2 default CHR(0),
                                 p_argument18  IN varchar2 default CHR(0),		  p_argument19  IN varchar2 default CHR(0),
                                 p_argument20  IN varchar2 default CHR(0),		  p_argument21  IN varchar2 default CHR(0),
                                 p_argument22  IN varchar2 default CHR(0),		  p_argument23  IN varchar2 default CHR(0),
                                 p_argument24  IN varchar2 default CHR(0),		  p_argument25  IN varchar2 default CHR(0),
                                 p_argument26  IN varchar2 default CHR(0),		  p_argument27  IN varchar2 default CHR(0),
                                 p_argument28  IN varchar2 default CHR(0),		  p_argument29  IN varchar2 default CHR(0),
                                 p_argument30  IN varchar2 default CHR(0),		  p_argument31  IN varchar2 default CHR(0),
                                 p_argument32  IN varchar2 default CHR(0),		  p_argument33  IN varchar2 default CHR(0),
                                 p_argument34  IN varchar2 default CHR(0),		  p_argument35  IN varchar2 default CHR(0),
                                 p_argument36  IN varchar2 default CHR(0),		  p_argument37  IN varchar2 default CHR(0),
                                 p_argument38  IN varchar2 default CHR(0),		  p_argument39  IN varchar2 default CHR(0),
                                 p_argument40  IN varchar2 default CHR(0),		  p_argument41  IN varchar2 default CHR(0),
                                 p_argument42  IN varchar2 default CHR(0),        p_argument43  IN varchar2 default CHR(0),
                                 p_argument44  IN varchar2 default CHR(0),		  p_argument45  IN varchar2 default CHR(0),
                                 p_argument46  IN varchar2 default CHR(0),		  p_argument47  IN varchar2 default CHR(0),
                                 p_argument48  IN varchar2 default CHR(0),        p_argument49  IN varchar2 default CHR(0),
                                 p_argument50  IN varchar2 default CHR(0),		  p_argument51  IN varchar2 default CHR(0),
                                 p_argument52  IN varchar2 default CHR(0),		  p_argument53  IN varchar2 default CHR(0),
                                 p_argument54  IN varchar2 default CHR(0),        p_argument55  IN varchar2 default CHR(0),
                                 p_argument56  IN varchar2 default CHR(0),		  p_argument57  IN varchar2 default CHR(0),
                                 p_argument58  IN varchar2 default CHR(0),		  p_argument59  IN varchar2 default CHR(0),
                                 p_argument60  IN varchar2 default CHR(0),		  p_argument61  IN varchar2 default CHR(0),
                                 p_argument62  IN varchar2 default CHR(0),		  p_argument63  IN varchar2 default CHR(0),
                                 p_argument64  IN varchar2 default CHR(0),		  p_argument65  IN varchar2 default CHR(0),
                                 p_argument66  IN varchar2 default CHR(0),		  p_argument67  IN varchar2 default CHR(0),
                                 p_argument68  IN varchar2 default CHR(0),		  p_argument69  IN varchar2 default CHR(0),
                                 p_argument70  IN varchar2 default CHR(0),        p_argument71  IN varchar2 default CHR(0),
                                 p_argument72  IN varchar2 default CHR(0),		  p_argument73  IN varchar2 default CHR(0),
                                 p_argument74  IN varchar2 default CHR(0),		  p_argument75  IN varchar2 default CHR(0),
                                 p_argument76  IN varchar2 default CHR(0),		  p_argument77  IN varchar2 default CHR(0),
                                 p_argument78  IN varchar2 default CHR(0),		  p_argument79  IN varchar2 default CHR(0),
                                 p_argument80  IN varchar2 default CHR(0),		  p_argument81  IN varchar2 default CHR(0),
                                 p_argument82  IN varchar2 default CHR(0),		  p_argument83  IN varchar2 default CHR(0),
                                 p_argument84  IN varchar2 default CHR(0),		  p_argument85  IN varchar2 default CHR(0),
                                 p_argument86  IN varchar2 default CHR(0),		  p_argument87  IN varchar2 default CHR(0),
                                 p_argument88  IN varchar2 default CHR(0),		  p_argument89  IN varchar2 default CHR(0),
                                 p_argument90  IN varchar2 default CHR(0),		  p_argument91  IN varchar2 default CHR(0),
                                 p_argument92  IN varchar2 default CHR(0), 		  p_argument93  IN varchar2 default CHR(0),
                                 p_argument94  IN varchar2 default CHR(0),		  p_argument95  IN varchar2 default CHR(0),
                                 p_argument96  IN varchar2 default CHR(0),		  p_argument97  IN varchar2 default CHR(0),
                                 p_argument98  IN varchar2 default CHR(0),		  p_argument99  IN varchar2 default CHR(0),
                                 p_argument100  IN varchar2 default CHR(0)		  ) RETURN NUMBER AS
        
    nmbUsuario                            NUMBER;
    nmbRetorno                            NUMBER;
    strEmail                              APPS.PER_ALL_PEOPLE_F.EMAIL_ADDRESS %TYPE;
    strUsername                           APPS.FND_USER.USER_NAME             %TYPE;
    strNome                               PER_ALL_PEOPLE_F.LAST_NAME     %TYPE;
    bolReturnStatus                       BOOLEAN;
    strPhase                              VARCHAR2(2000);
    strWaitStatus                         VARCHAR2 (2000);
    strDevPhase                           VARCHAR2 (2000);
    strDevStatus                          VARCHAR2 (2000);
    strMensagem                           VARCHAR2 (2000);
    strTextSaida                          VARCHAR2 (32000);
    strLinha                              VARCHAR2 (32000);
    utfHandle                             UTL_FILE.FILE_TYPE;
    strOutputFile                         APPS.FND_CONCURRENT_REQUESTS.outfile_name %TYPE;
 BEGIN
    BEGIN
       SELECT FU.USER_NAME, NVL(FU.EMAIL_ADDRESS, PAPF.EMAIL_ADDRESS) AS EMAIL, PAPF.LAST_NAME
         INTO strUsername, strEmail, strNome
         FROM APPS.FND_USER           FU,
              APPS.PER_ALL_PEOPLE_F   PAPF
        WHERE FU.USER_ID             = APPS.FND_PROFILE.VALUE('USER_ID')
          AND PAPF.PERSON_ID         = FU.EMPLOYEE_ID
          AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
          AND PAPF.BUSINESS_GROUP_ID = APPS.FND_PROFILE.VALUE('PER_BUSINESS_GROUP_ID');
    EXCEPTION
       WHEN OTHERS THEN
           strUsername := NULL;
           strEmail    := NULL;
           strNome     := NULL;
    END;
    nmbRetorno  := APPS.FND_REQUEST.SUBMIT_REQUEST (p_application,p_program,p_description,p_start_time,p_sub_request,p_argument1,p_argument2,p_argument3,p_argument4,p_argument5,p_argument6,p_argument7,p_argument8,p_argument9,p_argument10,p_argument11,p_argument12,p_argument13,p_argument14,p_argument15,p_argument16,p_argument17,p_argument18,p_argument19,p_argument20,p_argument21,p_argument22,p_argument23,p_argument24,p_argument25,p_argument26,p_argument27,p_argument28,p_argument29,p_argument30,p_argument31,p_argument32,p_argument33,p_argument34,p_argument35,p_argument36,p_argument37,p_argument38,p_argument39,p_argument40,p_argument41,p_argument42,p_argument43,p_argument44,p_argument45,p_argument46,p_argument47,p_argument48,p_argument49,p_argument50,p_argument51,p_argument52,p_argument53,p_argument54,p_argument55,p_argument56,p_argument57,p_argument58,p_argument59,p_argument60,p_argument61,p_argument62,p_argument63,p_argument64,p_argument65,p_argument66,p_argument67,p_argument68,p_argument69,p_argument70,p_argument71,p_argument72,p_argument73,p_argument74,p_argument75,p_argument76,p_argument77,p_argument78,p_argument79,p_argument80,p_argument81,p_argument82,p_argument83,p_argument84,p_argument85,p_argument86,p_argument87,p_argument88,p_argument89,p_argument90,p_argument91,p_argument92,p_argument93,p_argument94,p_argument95,p_argument96,p_argument97,p_argument98,p_argument99,p_argument100);
    FND_FILE.PUT_LINE (fnd_file.LOG,'Concurrent Request : ' || nmbRetorno );
    COMMIT;
    IF nmbRetorno IS NOT NULL THEN
      bolReturnStatus :=  APPS.FND_CONCURRENT.wait_for_request (REQUEST_ID   => nmbRetorno,
                                                                INTERVAL     => 10,
                                                                MAX_WAIT     => NULL,
                                                                PHASE        => strPhase,
                                                                STATUS       => strWaitStatus,
                                                                dev_phase    => strDevPhase,
                                                                dev_status   => strDevStatus,
                                                                MESSAGE      => strMensagem);
      BEGIN
        SELECT outfile_name  INTO strOutputFile
          FROM APPS.FND_CONCURRENT_REQUESTS
         WHERE request_id   = nmbRetorno; 
      EXCEPTION
         WHEN OTHERS THEN
              strOutputFile := NULL;
      END;
      IF strOutputFile IS NOT NULL THEN
         utfHandle := UTL_FILE.fopen(strOutputFile,'cara', 'r');
         IF UTL_FILE.is_open (utfHandle) THEN
            LOOP
              BEGIN
                 UTL_FILE.get_line (utfHandle, strLinha);
                 strTextSaida := strTextSaida || strLinha || UTL_TCP.crlf;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      EXIT;
              END;
            END LOOP;
         END IF;
         UTL_FILE.fclose (utfHandle);
         UTL_MAIL.send_attach_varchar2( sender     => 'horacio@cobra.com.br',
                                        recipients => 'horacio@cobra.com.br',
                                        subject    => 'Testmail',
                                        message    => 'Execução de Processo : ' || TO_CHAR(nmbretorno),
                                        attachment => strTextSaida,
                                        att_inline => FALSE);
      END IF;
     END IF;
     RETURN nmbretorno;
END getRequesteBusiness;
PROCEDURE setRelatorioBusiness(errbuf OUT VARCHAR2,retcode OUT VARCHAR2 ,p_nmbRelatorio IN NUMBER ,
                                        p_parametro1   IN VARCHAR2 DEFAULT NULL,p_parametro2   IN VARCHAR2 DEFAULT NULL ,
                                        p_parametro3   IN VARCHAR2 DEFAULT NULL,p_parametro4   IN VARCHAR2 DEFAULT NULL ,
                                        p_parametro5   IN VARCHAR2 DEFAULT NULL,p_parametro6   IN VARCHAR2 DEFAULT NULL ,
                                        p_parametro7   IN VARCHAR2 DEFAULT NULL,p_parametro8   IN VARCHAR2 DEFAULT NULL ,
                                        p_parametro9   IN VARCHAR2 DEFAULT NULL,p_parametro10  IN VARCHAR2 DEFAULT NULL ,
                                        p_parametro11  IN VARCHAR2 DEFAULT NULL,p_parametro12  IN VARCHAR2 DEFAULT NULL ,
                                        p_parametro13  IN VARCHAR2 DEFAULT NULL,p_tpRelatorio  IN VARCHAR2 DEFAULT 'XML' ) AS
  clbSQL        		            CLOB;
  clbSQLTemp     		            CLOB;
  bnrCursor     		            BINARY_INTEGER := DBMS_SQL.OPEN_CURSOR;
  bnrExecucao   		            BINARY_INTEGER;
  nmbColunas    		            NUMBER := 0;
  nmbContador                   NUMBER := 0;
  tabtypColunas 		            DBMS_SQL.DESC_TAB;
  strLinha                      VARCHAR2(32767);
  strVariavel                   VARCHAR2(4000);
  tabRefCursor                  SYS_REFCURSOR;
  strDescricaoRelatorio         COBRAQUERYTOXML.descricaorelatorio%TYPE;
  nmbRequestId                  APPS.FND_CONCURRENT_REQUESTS.REQUEST_ID%TYPE := APPS.FND_GLOBAL.CONC_REQUEST_ID;
  tabtypParametros              typarrayvarchar := typarrayvarchar();
BEGIN
  RETCODE := 0;
  FND_FILE.PUT_LINE(FND_FILE.LOG, 'Iniciando geração de relatório.. ' || TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
  FND_FILE.PUT_LINE(FND_FILE.LOG, 'Recebido Parametro ' || TO_CHAR(p_nmbRelatorio) || ' com o Request : ' || nmbRequestId);
  BEGIN
    SELECT descricaorelatorio,      sqlrelatorio   INTO strDescricaoRelatorio,     clbSQL
    FROM COBRAQUERYTOXML 
    WHERE IDRELATORIO = p_nmbRelatorio;
  EXCEPTION
    WHEN OTHERS THEN
         FND_FILE.PUT_LINE(FND_FILE.LOG, 'Problema na emissão do relatório ' || TO_CHAR(p_nmbRelatorio));
    RETCODE := 2;
    RAISE_APPLICATION_ERROR(-20001,'Erro: Identificação do Relatório. ' || SQLERRM);
  END;
  FND_FILE.PUT_LINE(FND_FILE.LOG, 'Iniciando a geração do XML ' || TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
  DBMS_LOB.CREATETEMPORARY(clbSQLtemp,TRUE);
  DBMS_LOB.COPY(clbSQLtemp, clbSQL,DBMS_LOB.getlength(clbSQL));
  FND_FILE.PUT_LINE(FND_FILE.LOG, 'Iniciando a geração do Arquivo ' || TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));  
  DBMS_SQL.PARSE           ( bnrCursor, clbSQLtemp, DBMS_SQL.NATIVE);
  DBMS_SQL.DESCRIBE_COLUMNS( bnrCursor, nmbColunas, tabtypColunas  );
  if P_PARAMETRO1 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro1' , p_parametro1);
  end if;
  if P_PARAMETRO2 is not null then
     DBMS_SQL.BIND_VARIABLE   ( BNRCURSOR, ':p_parametro2' , P_PARAMETRO2);
  END IF;  
  if P_PARAMETRO3 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro3' , p_parametro3);
  end if;
  if P_PARAMETRO4 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro4' , p_parametro4);
  END IF;  
  if P_PARAMETRO5 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro5' , p_parametro5);
  END IF;
  if P_PARAMETRO6 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro6' , p_parametro6);
  END IF;  
  if P_PARAMETRO7 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro7' , p_parametro7);
  END IF;
  if P_PARAMETRO8 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor,':p_parametro8' , p_parametro8);
  END IF;  
  if P_PARAMETRO9 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro9' , p_parametro9);
  end if;
  if P_PARAMETRO10 is not null then
     DBMS_SQL.BIND_VARIABLE   ( bnrCursor, ':p_parametro10' , p_parametro10);
  END IF;  


  -- Define as colunas que serão recebidas
  FOR i IN 1 .. nmbColunas loop
     DBMS_SQL.DEFINE_COLUMN(bnrCursor, i, strVariavel, 4000);
  END LOOP;
  tabtypParametros := cobra_utility_ebs.getConcParameter(nmbRequestId);
  -- Define o cabecalho do Arquivo
  IF    p_tpRelatorio   = 'HTML' THEN
     FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<html><head><title>' || strDescricaoRelatorio || '</title></head><body>');
  ELSIF p_tpRelatorio   = 'CSV' THEN
     FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'');
  ELSE
     FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<?xml version="1.0" encoding="ISO-8859-1"?>');
     FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<EBS_11_5_10_2>');
  END IF;

  -- Efetua a impressão dos Parametros Recebidos para constar na Folha Principal
  strLinha := '';  
  IF    p_tpRelatorio   = 'HTML' THEN
        strLinha := '<TABLE CELLPADDING=1><THEAD><TR><TH>PARAMETROS</TH></TR></THEAD><TBODY>';
  ELSE
        strLinha :='<PARAMETROS>';
  END IF;
  IF tabtypParametros.count > 0 THEN
    FOR i IN tabtypParametros.FIRST .. tabtypParametros.LAST loop
      IF    p_tpRelatorio   = 'HTML' THEN
          strLinha := strLinha  || '<TR><TD>' || tabtypParametros(i) || '</TD></TR>';
      ELSIF p_tpRelatorio   = 'CSV' THEN
          strLinha := strLinha  || tabtypParametros(i) || ';';
      ELSE
          strLinha := strLinha  || '<PARAMETRO'|| LPAD(I,2,'0') ||'>' || tabtypParametros(i) || '</PARAMETRO'|| LPAD(I,2,'0') ||'>';
      END IF;
    END LOOP;
    IF    p_tpRelatorio   = 'HTML' THEN
          strLinha := strLinha || '</TBODY><TFOOT><TR><TH>' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') || ' - POR: ' ||  fnd_global.user_name  || '</TH> </TR></TFOOT></TABLE><BR>';
    ELSE
        strLinha := strLinha || '<DATA_EMISSAO>' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') || '</DATA_EMISSAO><AUTOR>' || FND_GLOBAL.USER_NAME || '</AUTOR></PARAMETROS>';
    END IF;
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT,strLinha);
  END IF;
  FND_FILE.put_line( FND_FILE.LOG,'==> Entrando para executar o processo... ');
  bnrExecucao   := DBMS_SQL.EXECUTE(bnrCursor);
  strLinha      := ''; 
  FOR i IN 1 .. nmbColunas LOOP
    IF    p_tpRelatorio   = 'HTML' THEN
       strLinha := strLinha || '<TH>' || tabtypColunas(i).col_name || '</TH>';
    ELSIF p_tpRelatorio   = 'CSV' THEN
       strLinha := strLinha || tabtypColunas(i).col_name ||';';
    ELSE
       strLinha := strLinha || '<COLUNA'|| LPAD(I,2,'0') ||'>' || tabtypColunas(i).col_name || '</COLUNA'|| LPAD(I,2,'0') ||'>';
    END IF;   
  END LOOP;
  IF    p_tpRelatorio   = 'HTML' THEN
        strLinha := '<TABLE><THEAD><TR>' || strLinha || '</TR></THEAD><TBODY>';
  ELSIF p_tpRelatorio   = 'CSV' THEN
        strLinha := SUBSTR(strLinha,1,length(strLinha)-1);
  ELSE
        strLinha :='<CONTEUDO><LINHA>' || strLinha || '</LINHA>';
  END IF;
  FND_FILE.PUT_LINE(FND_FILE.OUTPUT,strLinha);
  
  WHILE DBMS_SQL.FETCH_ROWS(bnrCursor) > 0 LOOP
     strLinha    := '';
     nmbContador := nmbContador + 1;
     FOR i IN 1 .. nmbColunas LOOP
        DBMS_SQL.COLUMN_VALUE (bnrCursor, i, strVariavel);
        IF    p_tpRelatorio   = 'HTML' THEN
           strLinha := strLinha || '<TD>' || NVL(strVariavel,'--') || '</TD>';
        ELSIF p_tpRelatorio   = 'CSV' THEN
            strLinha := strLinha || NVL(strVariavel,'--') || ';';
        ELSE
            strLinha := strLinha || '<COLUNA' || LPAD(I,2,'0') ||'>' || NVL(strVariavel,'--') || '</COLUNA'||LPAD(I,2,'0')||'>';
        END IF;
     END LOOP;
     IF    p_tpRelatorio   = 'HTML' THEN
           FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<TR>' || strLinha || '</TR>');
     ELSIF p_tpRelatorio   = 'CSV' THEN
           FND_FILE.PUT_LINE(FND_FILE.OUTPUT,SUBSTR(strLinha,1, LENGTH(strLinha)-1));
     ELSE
            FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'<LINHA>' || strLinha || '</LINHA>');
      END IF;
  END LOOP;
  IF    p_tpRelatorio   = 'HTML' THEN
        FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'</TBODY><TFOOT><TR><TH>TOTAL DE ITENS IMPRESSOS: ' || to_char(nmbContador) || '</TR></TFOOT></TABLE></BODY></HTML>');
  ELSIF p_tpRelatorio   = 'CSV' THEN
        FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'Total de Itens Impressos: ' || to_char(nmbContador));
  ELSE
         FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'</CONTEUDO></EBS_11_5_10_2>');
  END IF;
  DBMS_SQL.CLOSE_CURSOR(bnrCursor); 
  FND_FILE.PUT_LINE(FND_FILE.LOG, 'Término do processo de geração de relatório.' || TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
EXCEPTION
   WHEN OTHERS THEN
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'Problema na emissão do relatório ' || TO_CHAR(p_nmbRelatorio));
        RETCODE := 2;
        RAISE_APPLICATION_ERROR(-20001,'Contacte a TI para informar o problema ' || SQLERRM || ' com ' || SQLCODE);
        IF DBMS_SQL.IS_OPEN(bnrCursor) THEN
            DBMS_SQL.CLOSE_CURSOR(bnrCursor); 
        END IF;
END setRelatorioBusiness;

FUNCTION getValidaSegEbsLogin  (p_username IN VARCHAR2,  p_password IN VARCHAR2) RETURN VARCHAR2 AS
  nmbUserId                APPS.FND_USER.USER_ID              %TYPE;
  nmbPersonId              APPS.PER_ALL_PEOPLE_F.PERSON_ID    %TYPE;
  strNome                  APPS.PER_ALL_PEOPLE_F.LAST_NAME    %TYPE;
  datEndDate               APPS.FND_USER.END_DATE             %TYPE;
  datStartDate             APPS.FND_USER.START_DATE             %TYPE;
  streMail                 APPS.PER_ALL_PEOPLE_F.EMAIL_ADDRESS%TYPE;
  bolRetorno               BOOLEAN;
  retTypLogin              typLogon; 
  strRetorno               VARCHAR2(100):= 'PASSWORD-INVALID';
  strUsuario               APPS.FND_USER.USER_NAME             %TYPE:= SUBSTR(UPPER(p_username),1,100);
  strPassword              VARCHAR2(100) := p_password;
  PRAGMA                   AUTONOMOUS_TRANSACTION;
 BEGIN
    INSERT INTO HORACIOTESTE1(DATA) VALUES(SYSDATE);
    COMMIT;
    retTypLogin  := cobra_utility.getAcesso(strUsuario ,  p_password);
    IF NVL(retTypLogin.COND,-1) <> 0 THEN
       RETURN strRetorno;
    END IF;
    
    /*
    BEGIN
     SELECT PAPF.PERSON_ID,PAPF.LAST_NAME, PAPF.EMAIL_ADDRESS     INTO nmbPersonId,strNome,streMail
       FROM APPS.PER_PERSON_TYPE_USAGES_F      PPTUF,
            APPS.PER_ALL_PEOPLE_F              PAPF,
            APPS.PER_PERSON_TYPES              PPT
      WHERE SYSDATE BETWEEN PPTUF.EFFECTIVE_START_DATE AND PPTUF.EFFECTIVE_END_DATE
        AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
        AND PPT.SYSTEM_PERSON_TYPE    = 'EMP'
        AND PAPF.BUSINESS_GROUP_ID    = 21
        AND PPT.BUSINESS_GROUP_ID     = PAPF.BUSINESS_GROUP_ID
        AND PPT.PERSON_TYPE_ID        = PPTUF.PERSON_TYPE_ID
        AND PAPF.PERSON_ID            = PPTUF.PERSON_ID
        AND PAPF.PERSON_ID            = retTypLogin.PERSON_ID ;
    EXCEPTION
      WHEN OTHERS THEN
           RETURN strRetorno;
    END;
    BEGIN
     SELECT USER_ID,start_date, END_DATE  INTO nmbUserId,datStartDate,datEndDate
       FROM APPS.FND_USER 
      WHERE EMPLOYEE_ID   = nmbPersonId
        AND USER_NAME     = strUsuario;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            nmbUserId := -1;
            datEndDate:= null;
       WHEN OTHERS THEN
            RETURN strRetorno;
    END;

     IF nmbUserId = -1 THEN
       APPS.FND_USER_PKG.CREATEUSER (x_user_name              => strUsuario,
                                     x_owner                  => 'CUST',
                                     x_description            => strNome,
                                     x_password_lifespan_days => APPS.FND_PROFILE.value('COBRA:VALIDADE_PASSWORD'),
                                     x_unencrypted_password   => strPassword,
                                     x_session_number         => USERENV ('sessionid'),
                                     x_start_date             => SYSDATE,
                                     x_password_date          => SYSDATE + APPS.FND_PROFILE.value('COBRA:VALIDADE_PASSWORD'),
                                     x_end_date               => NULL,
                                     x_email_address          => streMail,
                                     x_employee_id	          => nmbPersonId
                                     );
    ELSE
        APPS.FND_USER_PKG.EnableUser(username    => strUsuario,
                                     start_date  => datStartDate);
        COMMIT;
        bolRetorno := APPS.FND_USER_PKG.ChangePassword( username    => strUsuario , 
                                                        newpassword => strPassword);
    END IF;
    COMMIT;
    */
    RETURN 'PASSWORD-VALID';
 END getValidaSegEbsLogin;

END COBRA_UTILITY_EBS;