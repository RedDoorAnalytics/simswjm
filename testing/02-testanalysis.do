cd "~/R-dev/simswjm/testing"

**
** Gaussian
**

* Non-informative:
use d0g, clear
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d0g_glmm
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
	(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d0g_jm
//
estimates tab d0g_glmm d0g_jm
// export
etable, estimates(d0g_*) column(estimates) cstat(_r_b) export("d0g_b.xlsx", replace)
etable, estimates(d0g_*) column(estimates) cstat(_r_se) export("d0g_se.xlsx", replace)

* Informative:
use d1g, clear
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d1g_glmm
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
	(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d1g_jm
//
estimates tab d1g_glmm d1g_jm
// export
etable, estimates(d1g_*) column(estimates) cstat(_r_b) export("d1g_b.xlsx", replace)
etable, estimates(d1g_*) column(estimates) cstat(_r_se) export("d1g_se.xlsx", replace)

**
** Binomial
**

* Non-informative:
use d0b, clear
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(binomial)) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d0b_glmm
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(binomial)) ///
	(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d0b_jm
//
estimates tab d0b_glmm d0b_jm
// export
etable, estimates(d0b_*) column(estimates) cstat(_r_b) export("d0b_b.xlsx", replace)
etable, estimates(d0b_*) column(estimates) cstat(_r_se) export("d0b_se.xlsx", replace)

* Informative:
use d1b, clear
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(binomial)) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d1b_glmm
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(binomial)) ///
	(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d1b_jm
//
estimates tab d1b_glmm d1b_jm
// export
etable, estimates(d1b_*) column(estimates) cstat(_r_b) export("d1b_b.xlsx", replace)
etable, estimates(d1b_*) column(estimates) cstat(_r_se) export("d1b_se.xlsx", replace)

**
** Count
**

* Non-informative:
use d0c, clear
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d0c_glmm
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
	(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d0c_jm
//
estimates tab d0c_glmm d0c_jm
// export
etable, estimates(d0c_*) column(estimates) cstat(_r_b) export("d0c_b.xlsx", replace)
etable, estimates(d0c_*) column(estimates) cstat(_r_se) export("d0c_se.xlsx", replace)

* Informative:
use d1c, clear
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d1c_glmm
gsem ///
	(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
	(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
	, covstructure(M1[i] M2[i>id], diag) startgrid
estimates store d1c_jm
//
estimates tab d1c_glmm d1c_jm
// export
etable, estimates(d1c_*) column(estimates) cstat(_r_b) export("d1c_b.xlsx", replace)
etable, estimates(d1c_*) column(estimates) cstat(_r_se) export("d1c_se.xlsx", replace)
