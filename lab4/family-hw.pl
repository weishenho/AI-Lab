cyborg(curtis_brady).
cyborg(felix_snyder).
cyborg(garry_freeman).
cyborg(iris_tucker).
cyborg(linda_owens).
cyborg(meredith_elliott).
cyborg(olive_hall).
cyborg(roger_mccormick).
cyborg(samantha_wilson).
cyborg(wallace_moran).
female(lula_saunders).
female(luz_schultz).
female(mae_robertson).
female(sophia_schmidt).
female(terrell_kennedya).
female(tracy_wells).
male(dewey_price).
male(guadalupe_spencer).
male(guy_holloway).
male(lee_jenkins).
male(marty_cobb).
male(terrell_kennedy).
male(todd_glover).
married(guy_holloway, mae_robertson).
married(iris_tucker, roger_mccormick).
married(lee_jenkins, terrell_kennedya).
married(linda_owens, wallace_moran).
married(mae_robertson, guy_holloway).
married(roger_mccormick, iris_tucker).
married(samantha_wilson,todd_glover).
married(terrell_kennedy, tracy_wells).
married(terrell_kennedya, lee_jenkins).
married(todd_glover, samantha_wilson).
married(tracy_wells, terrell_kennedy).
married(wallace_moran, linda_owens).
parent(guadalupe_spencer, lula_saunders).
parent(guy_holloway, lee_jenkins).
parent(iris_tucker, felix_snyder).
parent(iris_tucker, garry_freeman).
parent(lee_jenkins, guadalupe_spencer).
parent(lee_jenkins, olive_hall).
parent(lee_jenkins, todd_glover).
parent(linda_owens, meredith_elliott).
parent(linda_owens, roger_mccormick).
parent(linda_owens, samantha_wilson).
parent(luz_schultz, lula_saunders).
parent(mae_robertson, lee_jenkins).
parent(roger_mccormick, felix_snyder).
parent(roger_mccormick, garry_freeman).
parent(samantha_wilson, dewey_price).
parent(samantha_wilson, marty_cobb).
parent(samantha_wilson, sophia_schmidt).
parent(terrell_kennedy, terrell_kennedya).
parent(terrell_kennedya, guadalupe_spencer).
parent(terrell_kennedya, olive_hall).
parent(terrell_kennedya, todd_glover).
parent(todd_glover, dewey_price).
parent(todd_glover, marty_cobb).
parent(todd_glover, sophia_schmidt).
parent(tracy_wells, terrell_kennedya).
parent(wallace_moran, meredith_elliott).
parent(wallace_moran, roger_mccormick).
parent(wallace_moran, samantha_wilson).

human(H) :- male(H).
human(H) :- female(H).
father(F,C) :- male(F),parent(F,C).
mother(M,C) :- female(M),parent(M,C).
is_father(F) :- father(F,_).
is_mother(M) :- mother(M,_).
