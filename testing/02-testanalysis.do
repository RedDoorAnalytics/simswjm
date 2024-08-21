cd "~/R-dev/simswjm/testing"


**
** Postfile with results
**

capture postclose pf
postfile pf str10(outcome) str20(term) double(inf model parameter b stderr true) using "testing.dta", replace

**
** Gaussian
**

foreach i of numlist 0 1 {
	// i = 0: not-informative
	// i = 1: informative
	use d`i'g, clear
	compress
	tab j, gen(ibnj)
	
	//
	if ("`i'" == "0") {
		local omega = 0.0
	}
	else {
		local omega = -0.1
	}

	//
	gsem ///
		(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
		, covstructure(M1[i] M2[i>id], diag) startgrid 
	post pf ("gaussian") ("y: j=1") (`i') (1) (1) (_b[yobs:1.j]) (_se[yobs:1.j]) (50)
	post pf ("gaussian") ("y: j=2") (`i') (1) (2) (_b[yobs:2.j]) (_se[yobs:2.j]) (50)
	post pf ("gaussian") ("y: j=3") (`i') (1) (3) (_b[yobs:3.j]) (_se[yobs:3.j]) (50)
	post pf ("gaussian") ("y: j=4") (`i') (1) (4) (_b[yobs:4.j]) (_se[yobs:4.j]) (50)
	post pf ("gaussian") ("y: j=5") (`i') (1) (5) (_b[yobs:5.j]) (_se[yobs:5.j]) (50)
	post pf ("gaussian") ("y: 1.x") (`i') (1) (6) (_b[yobs:1.x]) (_se[yobs:1.x]) (0.2)
	post pf ("gaussian") ("var(M1[i])") (`i') (1) (20) (_b[/:var(M1[i])]) (_se[/:var(M1[i])]) (1)
	post pf ("gaussian") ("var(M2[i>id])") (`i') (1) (21) (_b[/:var(M2[i>id])]) (_se[/:var(M2[i>id])]) (55)
	post pf ("gaussian") ("var(e)") (`i') (1) (22) (_b[/:var(e.yobs)]) (_se[/:var(e.yobs)]) (50)
	//
	gsem ///
		(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
		(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
		, covstructure(M1[i] M2[i>id], diag) startgrid 
	post pf ("gaussian") ("y: j=1") (`i') (2) (1) (_b[yobs:1.j]) (_se[yobs:1.j]) (50)
	post pf ("gaussian") ("y: j=2") (`i') (2) (2) (_b[yobs:2.j]) (_se[yobs:2.j]) (50)
	post pf ("gaussian") ("y: j=3") (`i') (2) (3) (_b[yobs:3.j]) (_se[yobs:3.j]) (50)
	post pf ("gaussian") ("y: j=4") (`i') (2) (4) (_b[yobs:4.j]) (_se[yobs:4.j]) (50)
	post pf ("gaussian") ("y: j=5") (`i') (2) (5) (_b[yobs:5.j]) (_se[yobs:5.j]) (50)
	post pf ("gaussian") ("y: 1.x") (`i') (2) (6) (_b[yobs:1.x]) (_se[yobs:1.x]) (0.2)
	post pf ("gaussian") ("t: 1.x") (`i') (2) (10) (_b[t:1.x]) (_se[t:1.x]) (-0.2)
	post pf ("gaussian") ("t: M1[i]") (`i') (2) (11) (_b[t:M1[i]]) (_se[t:M1[i]]) (`omega')
	post pf ("gaussian") ("t: M2[i>id]") (`i') (2) (12) (_b[t:M2[i>id]]) (_se[t:M2[i>id]]) (`omega')
	post pf ("gaussian") ("t: log(lambda)") (`i') (2) (13) (_b[t:_cons]) (_se[t:_cons]) (-1.5)
	post pf ("gaussian") ("t: log(p)") (`i') (2) (14) (_b[/t:ln_p]) (_se[/t:ln_p]) (0.0)
	post pf ("gaussian") ("var(M1[i])") (`i') (2) (20) (_b[/:var(M1[i])]) (_se[/:var(M1[i])]) (1)
	post pf ("gaussian") ("var(M2[i>id])") (`i') (2) (21) (_b[/:var(M2[i>id])]) (_se[/:var(M2[i>id])]) (55)
	post pf ("gaussian") ("var(e)") (`i') (2) (22) (_b[/:var(e.yobs)]) (_se[/:var(e.yobs)]) (50)
	//
	merlin ///
		(yobs ibnj1 ibnj2 ibnj3 ibnj4 ibnj5 x M1[i]@1 M2[i>id]@1, noconstant family(gaussian)) ///
		(t x M1[i] M2[i>id], family(weibull, failure(d) lt(t0)))
	post pf ("gaussian") ("y: j=1") (`i') (3) (1) (_b[_cmp_1_1_1:_cons]) (_se[_cmp_1_1_1:_cons]) (50)
	post pf ("gaussian") ("y: j=2") (`i') (3) (2) (_b[_cmp_1_2_1:_cons]) (_se[_cmp_1_2_1:_cons]) (50)
	post pf ("gaussian") ("y: j=3") (`i') (3) (3) (_b[_cmp_1_3_1:_cons]) (_se[_cmp_1_3_1:_cons]) (50)
	post pf ("gaussian") ("y: j=4") (`i') (3) (4) (_b[_cmp_1_4_1:_cons]) (_se[_cmp_1_4_1:_cons]) (50)
	post pf ("gaussian") ("y: j=5") (`i') (3) (5) (_b[_cmp_1_5_1:_cons]) (_se[_cmp_1_5_1:_cons]) (50)
	post pf ("gaussian") ("y: 1.x") (`i') (3) (6) (_b[_cmp_1_6_1:_cons]) (_se[_cmp_1_6_1:_cons]) (0.2)
	post pf ("gaussian") ("t: 1.x") (`i') (3) (10) (_b[_cmp_2_1_1:_cons]) (_se[_cmp_2_1_1:_cons]) (-0.2)
	post pf ("gaussian") ("t: M1[i]") (`i') (3) (11) (_b[_cmp_2_2_1:_cons]) (_se[_cmp_2_2_1:_cons]) (`omega')
	post pf ("gaussian") ("t: M2[i>id]") (`i') (3) (12) (_b[_cmp_2_3_1:_cons]) (_se[_cmp_2_3_1:_cons]) (`omega')
	post pf ("gaussian") ("t: log(lambda)") (`i') (3) (13) (_b[cons2:_cons]) (_se[cons2:_cons]) (-1.5)
	post pf ("gaussian") ("t: log(p)") (`i') (3) (14) (_b[dap2_1:_cons]) (_se[dap2_1:_cons])  (0.0)
	nlcom (exp(_b[lns1_1:_cons]))^2
	post pf ("gaussian") ("var(M1[i])") (`i') (3) (20) (r(table)[1,1]) (r(table)[2,1]) (1)
	nlcom (exp(_b[lns2_1:_cons]))^2
	post pf ("gaussian") ("var(M2[i>id])") (`i') (3) (21) (r(table)[1,1]) (r(table)[2,1]) (55)
	nlcom (exp(_b[dap1_1:_cons]))^2
	post pf ("gaussian") ("var(e)") (`i') (3) (22) (r(table)[1,1]) (r(table)[2,1]) (50)
}

**
** Binomial
**

foreach i of numlist 0 1 {
	// i = 0: not-informative
	// i = 1: informative
	use d`i'b, clear
	compress
	tab j, gen(ibnj)

	//
	if ("`i'" == "0") {
		local omega1 = 0.0
		local omega3 = 0.0
	}
	else {
		local omega1 = 1.0
		local omega3 = 0.4
	}	
	
	//
	gsem ///
		(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(binomial)) ///
		, covstructure(M1[i] M2[i>id], diag) startgrid 
	post pf ("binomial") ("y: j=1") (`i') (1) (1) (_b[yobs:1.j]) (_se[yobs:1.j]) (-2.0)
	post pf ("binomial") ("y: j=2") (`i') (1) (2) (_b[yobs:2.j]) (_se[yobs:2.j]) (-2.0)
	post pf ("binomial") ("y: j=3") (`i') (1) (3) (_b[yobs:3.j]) (_se[yobs:3.j]) (-2.0)
	post pf ("binomial") ("y: j=4") (`i') (1) (4) (_b[yobs:4.j]) (_se[yobs:4.j]) (-2.0)
	post pf ("binomial") ("y: j=5") (`i') (1) (5) (_b[yobs:5.j]) (_se[yobs:5.j]) (-2.0)
	post pf ("binomial") ("y: 1.x") (`i') (1) (6) (_b[yobs:1.x]) (_se[yobs:1.x]) (0.2)
	post pf ("binomial") ("var(M1[i])") (`i') (1) (20) (_b[/:var(M1[i])]) (_se[/:var(M1[i])]) (0.2)
	post pf ("binomial") ("var(M2[i>id])") (`i') (1) (21) (_b[/:var(M2[i>id])]) (_se[/:var(M2[i>id])]) (1.0)
	//
	gsem ///
		(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(binomial)) ///
		(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
		, covstructure(M1[i] M2[i>id], diag) startgrid 
	post pf ("binomial") ("y: j=1") (`i') (2) (1) (_b[yobs:1.j]) (_se[yobs:1.j]) (-2.0)
	post pf ("binomial") ("y: j=2") (`i') (2) (2) (_b[yobs:2.j]) (_se[yobs:2.j]) (-2.0)
	post pf ("binomial") ("y: j=3") (`i') (2) (3) (_b[yobs:3.j]) (_se[yobs:3.j]) (-2.0)
	post pf ("binomial") ("y: j=4") (`i') (2) (4) (_b[yobs:4.j]) (_se[yobs:4.j]) (-2.0)
	post pf ("binomial") ("y: j=5") (`i') (2) (5) (_b[yobs:5.j]) (_se[yobs:5.j]) (-2.0)
	post pf ("binomial") ("y: 1.x") (`i') (2) (6) (_b[yobs:1.x]) (_se[yobs:1.x]) (0.2)
	post pf ("binomial") ("t: 1.x") (`i') (2) (10) (_b[t:1.x]) (_se[t:1.x]) (-0.1)
	post pf ("binomial") ("t: M1[i]") (`i') (2) (11) (_b[t:M1[i]]) (_se[t:M1[i]]) (`omega1')
	post pf ("binomial") ("t: M2[i>id]") (`i') (2) (12) (_b[t:M2[i>id]]) (_se[t:M2[i>id]]) (`omega3')
	post pf ("binomial") ("t: log(lambda)") (`i') (2) (13) (_b[t:_cons]) (_se[t:_cons]) (-1.5)
	post pf ("binomial") ("t: log(p)") (`i') (2) (14) (_b[/t:ln_p]) (_se[/t:ln_p]) (0.0)
	post pf ("binomial") ("var(M1[i])") (`i') (2) (20) (_b[/:var(M1[i])]) (_se[/:var(M1[i])]) (0.2)
	post pf ("binomial") ("var(M2[i>id])") (`i') (2) (21) (_b[/:var(M2[i>id])]) (_se[/:var(M2[i>id])]) (1.0)
	//
	merlin ///
		(yobs ibnj1 ibnj2 ibnj3 ibnj4 ibnj5 x M1[i]@1 M2[i>id]@1, noconstant family(bernoulli)) ///
		(t x M1[i] M2[i>id], family(weibull, failure(d) lt(t0)))
	post pf ("binomial") ("y: j=1") (`i') (3) (1) (_b[_cmp_1_1_1:_cons]) (_se[_cmp_1_1_1:_cons]) (-2.0)
	post pf ("binomial") ("y: j=2") (`i') (3) (2) (_b[_cmp_1_2_1:_cons]) (_se[_cmp_1_2_1:_cons]) (-2.0)
	post pf ("binomial") ("y: j=3") (`i') (3) (3) (_b[_cmp_1_3_1:_cons]) (_se[_cmp_1_3_1:_cons]) (-2.0)
	post pf ("binomial") ("y: j=4") (`i') (3) (4) (_b[_cmp_1_4_1:_cons]) (_se[_cmp_1_4_1:_cons]) (-2.0)
	post pf ("binomial") ("y: j=5") (`i') (3) (5) (_b[_cmp_1_5_1:_cons]) (_se[_cmp_1_5_1:_cons]) (-2.0)
	post pf ("binomial") ("y: 1.x") (`i') (3) (6) (_b[_cmp_1_6_1:_cons]) (_se[_cmp_1_6_1:_cons]) (0.2)
	post pf ("binomial") ("t: 1.x") (`i') (3) (10) (_b[_cmp_2_1_1:_cons]) (_se[_cmp_2_1_1:_cons]) (-0.1)
	post pf ("binomial") ("t: M1[i]") (`i') (3) (11) (_b[_cmp_2_2_1:_cons]) (_se[_cmp_2_2_1:_cons]) (`omega1')
	post pf ("binomial") ("t: M2[i>id]") (`i') (3) (12) (_b[_cmp_2_3_1:_cons]) (_se[_cmp_2_3_1:_cons]) (`omega3')
	post pf ("binomial") ("t: log(lambda)") (`i') (3) (13) (_b[cons2:_cons]) (_se[cons2:_cons]) (-1.5)
	post pf ("binomial") ("t: log(p)") (`i') (3) (14) (_b[dap2_1:_cons]) (_se[dap2_1:_cons]) (0.0)
	nlcom (exp(_b[lns1_1:_cons]))^2
	post pf ("binomial") ("var(M1[i])") (`i') (3) (20) (r(table)[1,1]) (r(table)[2,1]) (0.2)
	nlcom (exp(_b[lns2_1:_cons]))^2
	post pf ("binomial") ("var(M2[i>id])") (`i') (3) (21) (r(table)[1,1]) (r(table)[2,1]) (1.0)
}

**
** Count
**

foreach i of numlist 0 1 {
	// i = 0: not-informative
	// i = 1: informative
	use d`i'c, clear
	compress
	tab j, gen(ibnj)

	//
	if ("`i'" == "0") {
		local omega1 = 0.0
		local omega3 = 0.0
	}
	else {
		local omega1 = 0.8
		local omega3 = 0.3
	}	
	
	//
	gsem ///
		(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
		, covstructure(M1[i] M2[i>id], diag) startgrid 
	post pf ("count") ("y: j=1") (`i') (1) (1) (_b[yobs:1.j]) (_se[yobs:1.j]) (-1.0)
	post pf ("count") ("y: j=2") (`i') (1) (2) (_b[yobs:2.j]) (_se[yobs:2.j]) (-1.0)
	post pf ("count") ("y: j=3") (`i') (1) (3) (_b[yobs:3.j]) (_se[yobs:3.j]) (-1.0)
	post pf ("count") ("y: j=4") (`i') (1) (4) (_b[yobs:4.j]) (_se[yobs:4.j]) (-1.0)
	post pf ("count") ("y: j=5") (`i') (1) (5) (_b[yobs:5.j]) (_se[yobs:5.j]) (-1.0)
	post pf ("count") ("y: 1.x") (`i') (1) (6) (_b[yobs:1.x]) (_se[yobs:1.x]) (0.1)
	post pf ("count") ("var(M1[i])") (`i') (1) (20) (_b[/:var(M1[i])]) (_se[/:var(M1[i])]) (0.3)
	post pf ("count") ("var(M2[i>id])") (`i') (1) (21) (_b[/:var(M2[i>id])]) (_se[/:var(M2[i>id])]) (1.7)
	//
	gsem ///
		(yobs <- ibn.j i.x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
		(t <- i.x M1[i] M2[i>id], family(weibull, failure(d) lt(t0))) ///
		, covstructure(M1[i] M2[i>id], diag) startgrid 
	post pf ("count") ("y: j=1") (`i') (2) (1) (_b[yobs:1.j]) (_se[yobs:1.j]) (-1.0)
	post pf ("count") ("y: j=2") (`i') (2) (2) (_b[yobs:2.j]) (_se[yobs:2.j]) (-1.0)
	post pf ("count") ("y: j=3") (`i') (2) (3) (_b[yobs:3.j]) (_se[yobs:3.j]) (-1.0)
	post pf ("count") ("y: j=4") (`i') (2) (4) (_b[yobs:4.j]) (_se[yobs:4.j]) (-1.0)
	post pf ("count") ("y: j=5") (`i') (2) (5) (_b[yobs:5.j]) (_se[yobs:5.j]) (-1.0)
	post pf ("count") ("y: 1.x") (`i') (2) (6) (_b[yobs:1.x]) (_se[yobs:1.x]) (0.1)
	post pf ("count") ("t: 1.x") (`i') (2) (10) (_b[t:1.x]) (_se[t:1.x]) (-0.2)
	post pf ("count") ("t: M1[i]") (`i') (2) (11) (_b[t:M1[i]]) (_se[t:M1[i]]) (`omega1')
	post pf ("count") ("t: M2[i>id]") (`i') (2) (12) (_b[t:M2[i>id]]) (_se[t:M2[i>id]]) (`omega3')
	post pf ("count") ("t: log(lambda)") (`i') (2) (13) (_b[t:_cons]) (_se[t:_cons]) (-1.5)
	post pf ("count") ("t: log(p)") (`i') (2) (14) (_b[/t:ln_p]) (_se[/t:ln_p]) (0.0)
	post pf ("count") ("var(M1[i])") (`i') (2) (20) (_b[/:var(M1[i])]) (_se[/:var(M1[i])]) (0.3)
	post pf ("count") ("var(M2[i>id])") (`i') (2) (21) (_b[/:var(M2[i>id])]) (_se[/:var(M2[i>id])]) (1.7)
	//
// 	merlin ///
// 		(yobs ibnj1 ibnj2 ibnj3 ibnj4 ibnj5 x M1[i]@1 M2[i>id]@1, noconstant family(poisson)) ///
// 		(t x M1[i] M2[i>id], family(weibull, failure(d) lt(t0)))
// 	post pf ("count") ("y: j=1") (`i') (3) (1) (_b[_cmp_1_1_1:_cons]) (_se[_cmp_1_1_1:_cons]) (-1.0)
// 	post pf ("count") ("y: j=2") (`i') (3) (2) (_b[_cmp_1_2_1:_cons]) (_se[_cmp_1_2_1:_cons]) (-1.0)
// 	post pf ("count") ("y: j=3") (`i') (3) (3) (_b[_cmp_1_3_1:_cons]) (_se[_cmp_1_3_1:_cons]) (-1.0)
// 	post pf ("count") ("y: j=4") (`i') (3) (4) (_b[_cmp_1_4_1:_cons]) (_se[_cmp_1_4_1:_cons]) (-1.0)
// 	post pf ("count") ("y: j=5") (`i') (3) (5) (_b[_cmp_1_5_1:_cons]) (_se[_cmp_1_5_1:_cons]) (-1.0)
// 	post pf ("count") ("y: 1.x") (`i') (3) (6) (_b[_cmp_1_6_1:_cons]) (_se[_cmp_1_6_1:_cons]) (0.1)
// 	post pf ("count") ("t: 1.x") (`i') (3) (10) (_b[_cmp_2_1_1:_cons]) (_se[_cmp_2_1_1:_cons]) (-0.2)
// 	post pf ("count") ("t: M1[i]") (`i') (3) (11) (_b[_cmp_2_2_1:_cons]) (_se[_cmp_2_2_1:_cons]) (`omega1')
// 	post pf ("count") ("t: M2[i>id]") (`i') (3) (12) (_b[_cmp_2_3_1:_cons]) (_se[_cmp_2_3_1:_cons]) (`omega3')
// 	post pf ("count") ("t: log(lambda)") (`i') (3) (13) (_b[cons2:_cons]) (_se[cons2:_cons]) (-1.5)
// 	post pf ("count") ("t: log(p)") (`i') (3) (14) (_b[dap2_1:_cons]) (_se[dap2_1:_cons]) (0.0)
// 	nlcom (exp(_b[lns1_1:_cons]))^2
// 	post pf ("count") ("var(M1[i])") (`i') (3) (20) (r(table)[1,1]) (r(table)[2,1]) (0.3)
// 	nlcom (exp(_b[lns2_1:_cons]))^2
// 	post pf ("count") ("var(M2[i>id])") (`i') (3) (21) (r(table)[1,1]) (r(table)[2,1]) (1.7)
}

***
*** Close postfile
***

postclose pf
