/* critérios max 3 (1 de cada tipo)
 */
pred inv1 {
    all j : Justificacao | #j.temCriterio <= 3
}

/* A suplementoPara B -> critério de utilidade administrativa em A a referir B
 */
pred inv2 {
	all A, B : ClasseSerie | (
        B in A.temSerieRelacionadaSuplementoPara implies (
            some c : CriterioUtilidadeAdministrativa |
                (A in c.temSerieRelacionada and c in B.temPCA.temJustificacao.temCriterio)
        )
    )
}

/* classe não pode ter em simultâneo relações de sinteseDe e eSintetizadoPor
 */
pred inv3 {
    all A : ClasseSerie | no A.eSinteseDe & A.eSintetizadoPor
}

fact invariantes {
    always (
        inv1 and
        inv2 and
        inv3
    )
}
