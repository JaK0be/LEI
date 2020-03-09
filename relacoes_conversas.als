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

    --sig ClasseSerie extends Classe {
    --    temPCA : set PCA,
    --    temDF : set DF,
    --    eCruzado : set ClasseSerie,
    --    eReferenciada : set AutoDeEliminacao -- relação referencia em dúvida
    --}

    --sig ClasseSubSerie extends Classe {
    --    temPCA : set PCA,
    --    temDF : set DF,
    --}

    --sig Entidade {
    --    revogaLeg : set Legislacao, -- não sei se tem converso
    --}

    --sig Legislacao {
    --    criaEntidadePorDiplomaNumero : set Entidade,
    --    extingueEntidadePorDiplomaNumero : set Entidade,
    --}

    --sig AutoDeEliminacao{
    --    referencia : set ClasseSerie + ClasseSubSerie, --Provavelmente esta errado
    --    aprovadoPor : set Entidade,
    --}
}

