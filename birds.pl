bird(laysan_albatross):-
    family(albatross),
    color(white).
bird(black_footed_albatros):-
    family(albatross),
    color(dark).
bird(whistling_swan):-
    family(swan),
    voice(muffled_musical_whistle).
bird(trumpeter_swan):-
    family(swan),
    voice(loud_trumpeting).
bird(canada_goose):-
    family(goose),
    season(winter),
    country(united_states),
    head(black),
    cheek(white).
bird(canada_goose):-
    family(goose),
    season(summer),
    country(canada),
    head(black),
    cheek(white).
bird(mallard):-
    family(duck),
    voice(quack),
    head(green).
bird(mallard):-
    family(duck),
    voice(quack),
    color(mottled_brown).
order(tubenose):-
    nostrils(external_tubular),
    live(at_sea),
    bill(hooked).
order(waterfowl) :-
    feet(webbed),
    bill(flat).

family(albatross):-
    order(tubenose),
    size(large),
    wings(long_narrow).
family(swan):-
    order(waterfowl),
    neck(long),
    color(white),
    flight(ponderous).

country(united_states):-region(mid_west).
country(united_states):-region(south_west).
country(united_states):-region(north_west).
country(united_states):-region(mid_atlantic).
country(canada):-province(ontario).
country(canada):-province(quebec).

region(new_england):-
    state(X),
    member(X, [massachusetts, vermont]).
region(south_west):-
    state(X),
    member(X, [florida, mississippi]).

region(X):-ask(region,X).
nostrils(X):-ask(nostrils,X).
live(X):-ask(live,X).
bill(X):-ask(bill,X).
size(X):-menuask(size,X, [large, plump, medium, small]).
wings(X):-ask(wings,X).
color(X):-ask(color,X).
feet(X):-ask(feet,X).
neck(X):-ask(neck,X).
flight(X):-menuask(flight,X, [ponderous, agile, flap_glide]).
province(X):-ask(province,X).
voice(X):-ask(voice,X).
season(X):-ask(season,X).
head(X):-ask(head,X).
cheek(X):-ask(cheek,X).
%BUG: there are problem with asking state(X) :/

multivalued(voice).
multivalued(feed).
% User interface
menuask(Attr,Val, _) :-
    \+ multivalued(Attr),
    known(yes,Attr,Val2),
    Val\=Val2,
    !,
    fail.

menuask(Attr,Val,_):-
    known(yes,Attr,Val),
    !.
menuask(Attr,Val,_):-
    known(_,Attr,Val),
    !,
    fail.

menuask(Attr,Val, MenuList) :-
    write('What is the value for '), write(Attr),write('?'),nl,
    write(MenuList),nl,
    read(X),
    check_val(X,Attr,Val, MenuList),
    asserta(known(yes, Attr, X)),
    X==Val.
check_val(X,_,_,MenuList):-
    member(X, MenuList),
    !.
check_val(X,A,V,MenuList):-
    write(X),write(' is not a legal value, try again.'),nl,
    menuask(A,V,MenuList).

ask(Attr,Val):-
    \+ multivalued(Attr),
    known(yes,Attr,Val2),
    Val\==Val2,
    !,
    fail.

ask(Attr,Val):-
    known(yes, Attr, Val),
    !.

ask(Attr,Val):-
    known(_,Attr,Val),
    !,
    fail.

ask(Attr,Val):-
    write(Attr:Val),
    write('? '),
    read(YesNo),
    asserta(known(YesNo, Attr, Val)),
    YesNo == yes.
