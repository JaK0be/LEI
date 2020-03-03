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
	legitimadoPor : set Entidade,
	eliminaDocAvaliadaPor : set RADA,
	referenciaUI : set UI
}
