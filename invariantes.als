/* Cada Justificacao tem no maximo 3 CriterioJustificacao diferentes */
pred inv1 {
    all j : Justificacao | #j.temCriterio <= 3
}

/* A suplementoPara B -> critério de utilidade administrativa em A a referir B
 */
pred inv2 {
	all A, B : ClasseSerie | (
        B in A.temSerieRelacionadaSuplementoPara implies (
            some c : CriterioUtilidadeAdministrativa |
                (A in c.temSerieRelacionada and c in B.temPCA.temJustificacaoPCA.temCriterio)
        )
    )
}

/* classe não pode ter em simultâneo relações de sinteseDe e eSintetizadoPor
 */
pred inv3 {
    all A : ClasseSerie | no A.eSinteseDe & A.eSintetizadaPor
    all A : ClasseSubSerie | no A.eSinteseDe & A.eSintetizadaPor
}

pred inv4 {
    all A, B : ClasseSerie | (
        B in A.eSintetizadaPor implies (
            A.temDF in Eliminacao
        )
    )
    all A : ClasseSubSerie, B : ClasseSerie | (
        B in A.eSintetizadaPor implies (
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
		!(some c.eComplementar) and (some c.eSinteseDe) => c.temDF in Conservacao
	}
	all c:ClasseSerie | no c.ePaiDeSubSerie => {
		!(some c.eComplementar) and !(some c.eSinteseDe) and (some c.eSintetizadaPor) => c.temDF in Eliminacao
	}
}

-- Se uma Classe pertence a uma TSRada, consequentemente os seus descendentes tambem têm de pertencer
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

-- Se uma Classe pertence não a uma TSRada, consequentemente os seus descendentes tambem não pertencem
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

-- As subseries herdam as legislações existentes nas series, quer para o PCA quer para o DF
pred inv10 {
	all c:ClasseSerie | some c.ePaiDeSubSerie => {
	(c.ePaiDeSubSerie.temPCA.temJustificacaoPCA.temCriterio.temLegislacao 
	 + c.ePaiDeSubSerie.temDF.temJustificacaoDF.temCriterio.temLegislacao) in c.reguladaPor
	}
}

/* As relações eComplementar e eCruzado são simétricas. */
pred inv11 {
	Symmetric[eComplementar]
	Symmetric[eCruzado]
}

/* 2 DFs nao podem ter a mesma instancia de Justificacao */
pred inv12 {
	all disj d1,d2:DF | d1.temJustificacaoDF != d2.temJustificacaoDF
}

/* 2 DFs nao podem ter a mesma instancia de Justificacao */
pred inv13 {
	all disj pca1,pca2:PCA | pca1.temJustificacaoPCA != pca2.temJustificacaoPCA
}

/* 2 Classes disjuntas nao podem ter a mesma instancia de DF */
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

/* 2 Classes disjuntas nao podem ter a mesma instancia de PCA */
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

/* 2 Justificações nao podem ter a mesma instancia de CriterioJustificacao */
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
	all pca:PCA | all crit:pca.temJustificacao.temCriterio {
					 		(crit in CriterioGestionario) or
							(crit in CriterioUtilidadeAdministrativa) or
							(crit in CriterioLegal)
						}
}

/* 2 Classes Serie nao podem ter os mesmos filhos */
pred inv19 {
	all disj c1,c2:ClasseSerie | all c3:ClasseSubSerie | c3 in c1.ePaiDeSubSerie => c3 not in c2.ePaiDeSubSerie
}

/*
	Cada justificação tem no máximo 1 Criterio de cada tipo.
*/
pred inv20 {
	all j:Justificacao {
		lone crit1:CriterioComplementaridadeInfo | crit1 in j.temCriterio
  		lone crit2:CriterioDensidadeInformacional | crit2 in j.temCriterio
  		lone crit3:CriterioGestionario | crit3 in j.temCriterio
  		lone crit4:CriterioLegal | crit4 in j.temCriterio
  		lone crit5:CriterioUtilidadeAdministrativa | crit5 in j.temCriterio
	}
}

-- Faltam Invariantes dos tipos de relação (pág 19)