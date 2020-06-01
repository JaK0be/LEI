open RelCalc

/*-- Especificação Entidades --*/

sig RADA  {
	contemRE : one RelatorioExpositivoRada, 
	contemTS : one TSRada, 
	aprovadoPorLeg : one Legislacao,
	revogadoPorLeg : one Legislacao,
	aprovadoPorEnt : set Entidade,
	revogadoPorEnt : set Entidade,
	eDaResponsabilidadeDe : one Entidade, 
	avaliaDocEliminadaPor : set AutoDeEliminacao	
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

sig PCA {
	temJustificacaoPCA : one JustificacaoPCA,
}

abstract sig DF{
	temJustificacaoDF : one JustificacaoDF
}
sig Eliminacao, Conservacao, CP extends DF{}

abstract sig Justificacao {
	temCriterio: some Criterio -- Tem no máximo 3 criterios
}
sig JustificacaoDF, JustificacaoPCA extends Justificacao {}

abstract sig Criterio{}

sig CriterioGestionario extends Criterio{
}

sig CriterioUtilidadeAdministrativa, CriterioComplementaridadeInfo, CriterioDensidadeInformacional extends Criterio{
	temSerieRelacionada : set ClasseSerie
}

sig CriterioLegal extends Criterio{
	temLegislacao : set Legislacao
}

abstract sig Classe {
	pertenceA : one TSRada,
}

sig ClasseN1 extends Classe {
	ePaiDeN2 : set ClasseN2,
	ePaiDeSerie : set ClasseSerie -- Perguntar se pode ser pai de serie
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
	eFilhaDeN1 : lone ClasseN1,
	eFilhaDeN2 : lone ClasseN2,
	eFilhaDeN3 : lone ClasseN3,
	ePaiDeSubSerie : set ClasseSubSerie,
	produzidaPorEnt : one Entidade, -- COnjunto definido em cima
	produzidaPorTipEnt : one TipologiaDeEntidade,  -- COnjunto definido em cima
	reguladaPor : set Legislacao,
	temPCA : lone PCA, -- Alterei para lone, para invariantes sobre df e pca fazerem sentido
	eSuplementoDe : set ClasseSerie,
	eSuplementoPara : set ClasseSerie,
	temDF : lone DF, -- Alterei para lone, para invariantes sobre df e pca fazerem sentido
	eComplementar : set ClasseSerie,
	eSintetizadaPorSerie : set ClasseSerie,
	eSinteseDeSerie : set ClasseSerie,
	temSucessor : set ClasseSerie,
	temAntecessor : set ClasseSerie,
	eCruzado : set ClasseSerie,
	ePaiDeUI : set UI,
	eReferenciada : set AutoDeEliminacao
}

sig ClasseSubSerie extends Classe {
	eFilhoDeSerie : one ClasseSerie,
	temPCA : one PCA,
	temDF : one DF,
	eSintetizadaPorSubSerie : set ClasseSubSerie,
	eSinteseDeSubSerie : set ClasseSubSerie,
	ePaiDeUI : set UI,
}

sig UI {
	eFilhoDeSerie : set ClasseSerie,
	eFilhoDeSubSerie : set ClasseSubSerie,
	referenciado : set AutoDeEliminacao,
	produzidaPorEnt : set Entidade, -- lone?
	produzidaPorTipEnt : set TipologiaDeEntidade
}

sig Entidade {
	antecede : set Entidade,
	sucede : set Entidade,
	integraCompetenciaDe : set Entidade,
	temCompetenciasIntegradasEm : set Entidade,
	estaIntegradaEm : set TipologiaDeEntidade, --talvez some
	eCriadaPorDiplomaNumero : one Legislacao,
	eExtintaPorDiplomaNumero : one Legislacao,
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
	prodDocAvaliadaPor : set RelatorioExpositivoRada,
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
	legitimadoPor : one Legislacao, -- Verificar  se está correto
	eliminaDocAvaliadaPor : set RADA,
	referenciaUI : set UI
}

/*-- Releções Inversas --*/
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
    eSuplementoDe = ~eSuplementoPara
    eComplementar = ~eComplementar -- relação simétrica
    eSintetizadaPorSerie = ~eSinteseDeSerie
    eSintetizadaPorSubSerie  = ~eSinteseDeSubSerie
    temSucessor = ~temAntecessor
    ClasseSerie <: ePaiDeUI = ~eFilhoDeSerie
    ClasseSubSerie <: ePaiDeUI = ~eFilhoDeSubSerie
    referenciado = ~referenciaUI
    antecede = ~sucede
    integraCompetenciaDe = ~temCompetenciasIntegradasEm
    estaIntegradaEm = ~integra
    criaEntidadePorDiplomaNumero = ~eCriadaPorDiplomaNumero
    extingueEntidadePorDiplomaNumero = ~eExtintaPorDiplomaNumero
    eResponsavelPorAE = ~eDaResponsabilidadeDe
    prodDocEliminadaPor = ~eliminaDocProduzidaPor
    aprovaLeg = ~aprovadaPor
    alteraLeg = ~alteradaPor
    revogaLeg = ~revogadaPor
    legitimaAE = ~legitimadoPor
}

/* Cada Justificacao tem no maximo 3 CriterioJustificacao diferentes */
pred inv1 {
    all j : Justificacao | #j.temCriterio <= 3
}

/* A suplementoPara B -> critério de utilidade administrativa em A a referir B
	1. A.temPCA.temJustificacaoPCA.temCriterio CriterioUtilidadeAdministrativa;
	2. CriterioUtilidadeAdministrativa c.temSerieRelacionada B;
	3. -> B suplementoDe A;
*/
pred inv2 {
	all A, B : ClasseSerie | (
        B in A.eSuplementoPara implies (
            some c : CriterioUtilidadeAdministrativa |
                (B in c.temSerieRelacionada and c in A.temPCA.temJustificacaoPCA.temCriterio)
        )
    )
}


/* Uma classe não pode ter em simultâneo relações de sinteseDe e eSintetizadoPor */
pred inv3 {
    all A : ClasseSerie | no A.eSinteseDeSerie & A.eSintetizadaPorSerie
    all A : ClasseSubSerie | no A.eSinteseDeSubSerie & A.eSintetizadaPorSubSerie
}

/* Se classe eSintetizadaPorSerie então o seu DF será eliminação*/
pred inv4 {
    all A, B : ClasseSerie | (
        B in A.eSintetizadaPorSerie implies (
            A.temDF in Eliminacao
        )
    )
    all A : ClasseSubSerie, B : ClasseSubSerie | (
        B in A.eSintetizadaPorSubSerie implies (
            A.temDF in Eliminacao
        )
    )
}

/* 
Se um PN é (por ordem de prioridade):
    - eComplementarDe   -> DF é de conservaçao
    - eSinteseDe        -> DF é de conservação
    - eSintetizadaPor   -> DF é de eliminação
*/
pred inv5 {
	all c:ClasseSerie | no c.ePaiDeSubSerie => {
		some c.eComplementar => c.temDF in Conservacao
	}
	all c:ClasseSerie | no c.ePaiDeSubSerie => {
		!(some c.eComplementar) and (some c.eSinteseDeSerie) => c.temDF in Conservacao
	}
	all c:ClasseSerie | no c.ePaiDeSubSerie => {
		!(some c.eComplementar) and !(some c.eSinteseDeSerie) and (some c.eSintetizadaPorSerie) => c.temDF in Eliminacao
	}
}

/* Se uma Classe pertence a uma TSRada, consequentemente os seus descendentes tambem têm de pertencer */
pred inv6 {
	all c:ClasseN1,ts:TSRada | ts = c.pertenceA =>
		(all cf:c.ePaiDeN2 | ts = cf.pertenceA) and
        (all cfserie:c.ePaiDeSerie | ts = cfserie.pertenceA)

    all c:ClasseN2,ts:TSRada | ts = c.pertenceA =>
        (all cf:c.ePaiDeN3 | ts = cf.pertenceA) and
        (all cfserie:c.ePaiDeSerie | ts = cfserie.pertenceA)

    all c:ClasseN3,ts:TSRada | ts = c.pertenceA =>
        (all cfserie:c.ePaiDeSerie | ts = cfserie.pertenceA) 
    
    all c:ClasseSerie,ts:TSRada | ts = c.pertenceA =>
        (all cfsubserie:c.ePaiDeSubSerie | ts = cfsubserie.pertenceA)
}

/* Se uma Classe não pertence a uma TSRada, consequentemente os seus descendentes tambem não pertencem */
pred inv7 {
	all c:ClasseN1 | no c.pertenceA =>
		(all cf:c.ePaiDeN2 | no cf.pertenceA) and
        (all cfserie:c.ePaiDeSerie | no cfserie.pertenceA)

    all c:ClasseN2 | no c.pertenceA =>
        (all cf:c.ePaiDeN3 | no cf.pertenceA) and
        (all cfserie:c.ePaiDeSerie | no cfserie.pertenceA)

    all c:ClasseN3 | no c.pertenceA =>
        (all cfserie:c.ePaiDeSerie | no cfserie.pertenceA) 
    
    all c:ClasseSerie | no c.pertenceA =>
        (all cfsubserie:c.ePaiDeSubSerie | no cfsubserie.pertenceA)
}

/* As relações temDF e temPCA, não existem numa classe serie se esta tiver filhos. */
pred inv8 {
	all c:ClasseSerie | some c.ePaiDeSubSerie => no c.temDF and no c.temPCA
}

/* As relações temDF e temPCA, existem numa classe serie se esta não tiver filhos. */
pred inv9 {
	all c:ClasseSerie | no c.ePaiDeSubSerie => one c.temDF and one c.temPCA
}

/* Justificações/Criterios/DF/PCA necessitam de pertencer a uma qualquer entidade no modelo */
pred inv10 {
	all j:JustificacaoDF | j in DF.temJustificacaoDF
	all j:JustificacaoPCA | j in PCA.temJustificacaoPCA
	all df:DF | df in (ClasseSerie.temDF + ClasseSubSerie.temDF)
	all pca:PCA | pca in (ClasseSerie.temPCA + ClasseSubSerie.temPCA)
	all c:Criterio | c  in Justificacao.temCriterio
}

/* As relações eComplementar e eCruzado são simétricas. */
pred inv11 {
	Symmetric[eComplementar]
	Symmetric[eCruzado]
}

/* 2 DFs disjuntos não podem ter a mesma instância de Justificacao */
pred inv12 {
	all disj d1,d2:DF | d1.temJustificacaoDF != d2.temJustificacaoDF
}

/* 2 PCAs disjuntos não podem ter a mesma instância de Justificacao */
pred inv13 {
	all disj pca1,pca2:PCA | pca1.temJustificacaoPCA != pca2.temJustificacaoPCA
}

/* 2 Classes disjuntas não podem ter a mesma instância de DF */
pred inv14 {
	all disj c1,c2:ClasseSerie {
		c1.temDF != c2.temDF
	}
	all disj c1,c2:ClasseSubSerie {
		c1.temDF != c2.temDF
	}
	all disj c1:ClasseSerie,c2:ClasseSubSerie {
		c1.temDF != c2.temDF
	}
}

/* 2 Classes disjuntas não podem ter a mesma instância de PCA */
pred inv15 {
	all disj c1,c2:ClasseSerie {
		c1.temPCA != c2.temPCA
	}
	all disj c1,c2:ClasseSubSerie {
		c1.temPCA != c2.temPCA
	}
	all disj c1:ClasseSerie,c2:ClasseSubSerie {
		c1.temPCA != c2.temPCA
	}
}

/* 2 Justificações não podem ter a mesma instância de CriterioJustificacao */
pred inv16 {
	all disj j1,j2:Justificacao | all c:Criterio | c in j1.temCriterio => c not in j2.temCriterio
}

/* Um DF, na sua justificação, deverá conter apenas critérios de densidade informacional, complementaridade informacional e legal */
pred inv17 {
	all df:DF | all crit:df.temJustificacaoDF.temCriterio {
					 		(crit in CriterioDensidadeInformacional) or
							(crit in CriterioComplementaridadeInfo) or
							(crit in CriterioLegal)
						}
}

/* Um PCA, na sua justificação, deverá conter apenas critérios gestionários, utilidade administrativa e legal */
pred inv18 {
	all pca:PCA | all crit:pca.temJustificacaoPCA.temCriterio {
					 		(crit in CriterioGestionario) or
							(crit in CriterioUtilidadeAdministrativa) or
							(crit in CriterioLegal)
						}
}

/* 2 Classes Série disjuntas não podem ter os mesmos filhos */
pred inv19 {
	all disj c1,c2:ClasseSerie | all c3:ClasseSubSerie | c3 in c1.ePaiDeSubSerie => c3 not in c2.ePaiDeSubSerie
}

/* Cada justificação tem no máximo 1 Criterio de cada tipo. */
pred inv20 {
	all j:Justificacao {
		lone crit1:CriterioComplementaridadeInfo | crit1 in j.temCriterio
  		lone crit2:CriterioDensidadeInformacional | crit2 in j.temCriterio
  		lone crit3:CriterioGestionario | crit3 in j.temCriterio
  		lone crit4:CriterioLegal | crit4 in j.temCriterio
  		lone crit5:CriterioUtilidadeAdministrativa | crit5 in j.temCriterio
	}
}

/* Um relatório expositivo só pode ser produzido por uma entidade ou por uma tipologia */
pred inv21 {
	all reRada:RelatorioExpositivoRada{
		some reRada.avaliaDocProduzidaPorEnt implies no reRada.avaliaDocProduzidaPorTipEnt
		some reRada.avaliaDocProduzidaPorTipEnt implies no reRada.avaliaDocProduzidaPorEnt
	} 
}

/* Uma classe série só pode ser produzida por uma entidade ou por uma tipologia */
pred inv22 {
	all c:ClasseSerie{
		some c.produzidaPorEnt implies no c.produzidaPorTipEnt
		some c.produzidaPorTipEnt implies no c.produzidaPorEnt
	} 
}

/* Uma UI só pode ser produzido por uma entidade ou por uma tipologia */
pred inv23 {
	all ui:UI{
		some ui.produzidaPorEnt implies no ui.produzidaPorTipEnt
		some ui.produzidaPorTipEnt implies no ui.produzidaPorEnt
	} 
}

/* Uma classe série só pode ser filha de uma única classe do tipo N */
pred inv24 {
	all c:ClasseSerie{
		some c.eFilhaDeN1 implies no c.eFilhaDeN2 and no c.eFilhaDeN3
		some c.eFilhaDeN2 implies no c.eFilhaDeN1 and no c.eFilhaDeN3
		some c.eFilhaDeN3 implies no c.eFilhaDeN2 and no c.eFilhaDeN1
	}
}

/* Legislação da justificação de PCA e DF pertencem à legislação da classe série pai */
pred inv25 {
	all c:ClasseSerie{
		 c.temDF.temJustificacaoDF.temCriterio.temLegislacao in c.reguladaPor
		 c.temPCA.temJustificacaoPCA.temCriterio.temLegislacao in c.reguladaPor

		 c.ePaiDeSubSerie.temDF.temJustificacaoDF.temCriterio.temLegislacao in c.reguladaPor
		 c.ePaiDeSubSerie.temPCA.temJustificacaoPCA.temCriterio.temLegislacao in c.reguladaPor
	}
}

/* 
     A eComplementarDe B -> critério de complementaridade informacional nas just. do DF de A e B;
     	1. B tem que ser referenciado no critério de complementaridade de A;
     	2. A tem que ser referenciado no critério de complementaridade de B; 
*/
pred inv26 {
	all A, B : ClasseSerie | (
		B in A.eComplementar implies (
			some c : CriterioComplementaridadeInfo |
				(c in A.temDF.temJustificacaoDF.temCriterio and B in c.temSerieRelacionada)
		)
	)
}

/* A eSinteseDe B -> critério de densidade informacional just. do DF de A e B;
	1. B tem que ser referenciado no critério de densidade de A;
	2. Adicionada relação inversa em B;
	3. A tem que ser referenciado no critério de densidade de B; 
*/
pred inv27 {
	all A, B : ClasseSerie | (
		B in A.eSinteseDeSerie implies (
			some c : CriterioDensidadeInformacional |
				(c in A.temDF.temJustificacaoDF.temCriterio and B in c.temSerieRelacionada)	
		)	
	)
}

/*Uma entidade não se sucede a si própria */
pred inv28{
	all e:Entidade | e not in e.sucede
}

run {
	 inv1
	 inv2
	 inv3
	 inv4
	 inv5
	 inv6
	 inv7
	 inv8
	 inv9
	 inv10
	 inv11
	 inv12
	 inv13
	 inv14
	 inv15
	 inv16
	 inv17
	 inv18
	 inv19
	 inv20
	 inv21
	 inv22
	 inv23
	 inv24
	 inv25
	 inv26
	 inv27
	 inv28
}
