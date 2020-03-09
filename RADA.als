sig RADA  {
	contemRE : one RelatorioExpositivoRada, -- Ver se é set ou não
	contemTS : one TSRada, -- Ver se é set ou não
	aprovadoPorLeg : set Legislacao,
	revogadoPorLeg : set Legislacao,
	aprovadoPorEnt : set Entidade,
	revogadoPorEnt : set Entidade,
	eDaResponsabilidadeDe : set Entidade,
	avaliaDocEliminadaPor : set AutoEliminacao	
}

sig RelatorioExpositivoRada {
	eParteDeRADA : one RADA,
	avaliaDocProduzidaPorEnt : set Entidade,
	avaliaDocProduzidaPorTipEnt : set TipologiaDeEntidade
}

sig TSRada {
	eParteDeRADA : one RADA,
	temClasse : set Classe
}

/* Relações Compostas */
sig PCA {
	temJustificacaoPCA : one Justificacao,
	valor: one Int
}

abstract sig DF{
	temJustificacaoDF : one Justificacao
}
sig Eliminacao, Conservacao, CP extends DF{}

abstract sig Justificacao {
	temCriterio: some Criterio
}
sig JustificacaoDF, JustificacaoPCA extends Justificacao {}

abstract sig Criterio{
	temLegislacao : set Legislacao
}
sig CriterioLegal, CriterioUtilidadeAdministrativa, CriterioGestionario, CriterioDensidadeInformal, CriterioComplementaridadeInfo extends Criterio{
	temSerieRelacionada : set ClasseSerie
}
/*--------------------*/

abstract sig Classe {
	pertenceA : one TSRada,
}

sig ClasseN1 extends Classe {
	ePaiDeN2 : set ClassN2,
	ePaiDeSerie : set ClasseSerie
}

sig ClasseN2 extends Classe {
	eFilhoDeN1 : one ClasseN1,
	ePaiDeN3 : set ClasseN3,
	ePaiDeSerie : set ClasseSerie
}

sig ClasseN3 extends Classe {
	eFilhoDeN2 : one ClasseN2,
	ePaiDeSerie : set ClasseSerie
}

sig ClasseSerie extends Classe {
	eFilhaDeN1 : one ClasseN1,
	eFilhaDeN2 : one ClasseN2,
	eFilhaDeN3 : one ClasseN3,
	ePaiDeSubSerie : set ClasseSubSerie,
	produzidaPorEnt : set Entidade,
	produzidaPorTipEnt : set TipologiaDeEntidade,
	reguladaPor : set Legislacao,
	temPCA : set PCA,
	temSerieRelacionadaSuplementoDe : set ClasseSerie,
	temSerieRelacionadaSuplementoPara : set ClasseSerie,
	temDF : set DF,
	eComplementar : set ClasseSerie,
	eSintetizadaPor : set ClasseSerie,
	eSinteseDe : set ClasseSerie,
	temSucessor : set ClasseSerie,
	temAntecessor : set ClasseSerie,
	eCruzado : set ClasseSerie,
	ePaiDeUI : set UI,
	eReferenciada : set AutoDeEliminacao
}

sig ClasseSubSerie extends Classe {
	eFilhoDeSerie : one ClasseSerie,
	temPCA : set PCA,
	temDF : set DF,
	eSintetizadaPor : set ClasseSerie,
	eSinteseDe : set ClasseSerie,
	ePaiDeUI : set UI,
}

sig UI {
	eFilhoDeSerie : set ClasseSerie,
	eFilhoDeSubSerie : set ClasseSubSerie,
	referenciado : set AutoDeEliminacao,
	produzidaPorEnt : set Entidade,
	produzidaPorTipEnt : set TipologiaDeEntidade
}

sig Entidade {
	antecede : set Entidade,
	sucede : set Entidade,
	integraCompetenciaDe : set Entidade,
	temCompetenciasIntegradasEm : set Entidade,
	estaIntegradaEm : set TipologiaDeEntidade, --talvez some
	eCriadaPorDiplomaNumero : set Legislacao,
	eExtintaPorDiplomaNumero : set Legislacao,
	aprovaLeg : set Legislacao,
	revogaLeg : set Legislacao,
	aprovaRADA : set RADA,
	revogaRADA :  set RADA,
	eResponsavelPor : set RADA,
	prodDocAvaliadaPor : set RelatorioExpositivoRada,
	eResponsavelPorAE : set AutoDeEliminacao,
	prodDocEliminadaPor : set AutoDeEliminacao,
	produzSerie : set ClasseSerie,
	produzUI : set UI
}

sig TipologiaDeEntidade {
	integra : set Entidade,
	prodDocAvaliadaPor : RelatorioExpositivoRada,
	produzSerie : set ClasseSerie,
	produzUI : set UI
}

sig Legislacao {
	alteraLeg : set Legislacao,
	revogaLeg : set Legislacao,
	alteradaPor : set Legislacao,
	revogadaPor : set Legislacao,
	criaEntidadePorDiplomaNumero : set Entidade,
	extingueEntidadePorDiplomaNumero : set Entidade,
	aprovadaPor : set Entidade,
	regulaSerie : set ClasseSerie,
	aprovaRADA : set RADA,
	revogaRADA : set RADA,
	legitimaAE : set AutoDeEliminacao
}

sig AutoDeEliminacao{
	referencia : set ClasseSerie + ClasseSubSerie, --Provavelmente esta errado
	eliminaDocProduzidaPor : set Entidade,
	eDaResponsabilidadeDe : set Entidade,
	aprovadoPor : set Entidade,
	legitimadoPor : set Legislacao,
	eliminaDocAvaliadaPor : set RADA,
	referenciaUI : set UI
}

/* Factos */
fact {
    contemRE = ~eParteDeRADA
    contemTS = ~eParteDeRADA
    aprovadoPorLeg = ~aprovaRADA
    revogadoPorLeg = ~revogaRADA
    aprovadoPorEnt = ~aprovaRADA
    revogadoPorEnt = ~revogaRADA
    eDaResponsabilidadeDe = ~eResponsavelPor
    avaliaDocEliminadaPor = ~eliminaDocAvaliadaPor
    avaliaDocProduzidaPorEnt = ~prodDocAvaliadaPor
    avaliaDocProduzidaPorTipEnt = ~prodDocAvaliadaPor
    temClasse = ~pertenceA
    ePaiDeN2 = ~eFilhoDeN1
    ePaiDeN3 = ~eFilhoDeN2
    ClasseN1 <: ePaiDeSerie = ~eFilhaDeN1
    ClasseN2 <: ePaiDeSerie = ~eFilhaDeN2
    ClasseN3 <: ePaiDeSerie = ~eFilhaDeN3
    ePaiDeSubSerie = ~eFilhoDeSerie
    ClasseSerie <: produzidaPorEnt = ~(Entidade <: produzSerie)
    ClasseSerie <: produzidaPorTipEnt = ~(TipologiaDeEntidade <: produzSerie)
    UI <: produzidaPorEnt = ~(Entidade <: produzUI)
    UI <: produzidaPorTipEnt = ~(TipologiaDeEntidade <: produzUI)
    reguladaPor = ~regulaSerie
    temSerieRelacionadaSuplementoDe = ~temSerieRelacionadaSuplementoPara
    eComplementar = ~eComplementar -- relação simétrica
    eSintetizadaPor = ~eSinteseDe
    temSucessor = ~temAntecessor
    ClasseSerie <: ePaiDeUI = ~eFilhoDeSerie
    eSintetizadaPor = ~eSinteseDe
    ClasseSubSerie <: ePaiDeUI = ~eFilhoDeSubSerie
    referenciado = ~referenciaUI
    antecede = ~sucede
    integraCompetenciaDe = ~temCompetenciasIntegradasEm
    estaIntegradaEm = ~integra
    eCriadaPorDiplomaNumero = ~eExtintaPorDiplomaNumero
    eResponsavelPorAE = ~eDaResponsabilidadeDe
    prodDocEliminadaPor = ~eliminaDocProduzidaPor
    aprovaLeg = ~aprovadaPor
    alteraLeg = ~alteradaPor
    revogaLeg = ~revogadaPor
    legitimaAE = ~legitimadoPor
}
