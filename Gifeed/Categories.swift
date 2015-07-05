//
//  Categories.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 7/5/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import Foundation

class Categories {
    
    let categoriesArray = [
        Category(name: "ACTIONS", subCategories: [
            SubCategory(name: "CRYING"),
            SubCategory(name: "DANCING"),
            SubCategory(name: "EATING"),
            SubCategory(name: "FALLING"),
            SubCategory(name: "FINGER GUNS"),
            SubCategory(name: "LAUGHING"),
            SubCategory(name: "MIDDLE FINGER"),
            SubCategory(name: "SLEEPING"),
            SubCategory(name: "SMILING")
            ]),
        Category(name: "ADJECTIVES", subCategories: [
            SubCategory(name: "BLACK AND WHITE"),
            SubCategory(name: "COLD"),
            SubCategory(name: "CUTE"),
            SubCategory(name: "KAWAII"),
            SubCategory(name: "NOSTALGIA"),
            SubCategory(name: "SLOW MOTION"),
            SubCategory(name: "TRIPPY"),
            SubCategory(name: "VINTAGE"),
            SubCategory(name: "WEIRD")
            ]),
        Category(name: "ANIMALS", subCategories: [
            SubCategory(name: "CAT"),
            SubCategory(name: "DOG"),
            SubCategory(name: "GOAT"),
            SubCategory(name: "HEDGEHOG"),
            SubCategory(name: "MONKEY"),
            SubCategory(name: "OTTER"),
            SubCategory(name: "PANDA"),
            SubCategory(name: "RABBIT"),
            SubCategory(name: "SLOTH")
            ]),
        Category(name: "ANIME", subCategories: [
            SubCategory(name: "COWBOY BEBOP"),
            SubCategory(name: "FLCL"),
            SubCategory(name: "HAMTARO"),
            SubCategory(name: "NARUTO"),
            SubCategory(name: "ONE PIECE"),
            SubCategory(name: "POKEMON"),
            SubCategory(name: "SAILOR MOON"),
            SubCategory(name: "SPIRITED AWAY"),
            SubCategory(name: "TRIGUN")
            ]),
        Category(name: "ART & DESIGN", subCategories: [
            SubCategory(name: "ARCHITECTURE"),
            SubCategory(name: "CINEMAGRAPH"),
            SubCategory(name: "GLITCH"),
            SubCategory(name: "LOOP"),
            SubCategory(name: "MASH UP"),
            SubCategory(name: "PIXEL"),
            SubCategory(name: "SCULPTURE"),
            SubCategory(name: "TIMELAPSE"),
            SubCategory(name: "TYPOGRAPHY")
            ]),
        Category(name: "CARTOONS & COMICS", subCategories: [
            SubCategory(name: "ADVENTURE TIME"),
            SubCategory(name: "ARCHER"),
            SubCategory(name: "FUTURAMA"),
            SubCategory(name: "KING STAR KING"),
            SubCategory(name: "MINIONS"),
            SubCategory(name: "REGULAR SHOW"),
            SubCategory(name: "SPONGEBOB SQUAREPANTS"),
            SubCategory(name: "THE BOONDOCKS"),
            SubCategory(name: "THE SIMPSONS")
            ]),
        Category(name: "CELEBRITIES", subCategories: [
            SubCategory(name: "AUBREY PLAZA"),
            SubCategory(name: "BILL MURRAY"),
            SubCategory(name: "EMMA STONE"),
            SubCategory(name: "JAMIE DORAN"),
            SubCategory(name: "JENNIFER LAWRENCE"),
            SubCategory(name: "JIM CARREY"),
            SubCategory(name: "LEONARDO DICAPRIO"),
            SubCategory(name: "SCARLETT JOHANSSON"),
            SubCategory(name: "WILL FERRELL")
            ]),
        Category(name: "DECADES", subCategories: [
            SubCategory(name: "20s"),
            SubCategory(name: "30s"),
            SubCategory(name: "40s"),
            SubCategory(name: "50s"),
            SubCategory(name: "60s"),
            SubCategory(name: "70s"),
            SubCategory(name: "80s"),
            SubCategory(name: "90s"),
            SubCategory(name: "VINTAGE")
            ]),
        Category(name: "EMOTIONS", subCategories: [
            SubCategory(name: "AWKWARD"),
            SubCategory(name: "BORED"),
            SubCategory(name: "CONFUSED"),
            SubCategory(name: "DRUNK"),
            SubCategory(name: "EXCITED"),
            SubCategory(name: "FRUSTRATED"),
            SubCategory(name: "HUNGRY"),
            SubCategory(name: "MIND BLOWN"),
            SubCategory(name: "TIRED")
            ]),
        Category(name: "FASHION & BEAUTY", subCategories: [
            SubCategory(name: "CARA DELEVINGNE"),
            SubCategory(name: "CHANEL"),
            SubCategory(name: "DIOR"),
            SubCategory(name: "KARLIE KLOSS"),
            SubCategory(name: "KATE MOSS"),
            SubCategory(name: "MAKEUP"),
            SubCategory(name: "MIRANDA KERR"),
            SubCategory(name: "RUNWAY"),
            SubCategory(name: "VICTORIAS SECRET")
            ]),
        Category(name: "FOOD & DRINK", subCategories: [
            SubCategory(name: "ALCOHOL"),
            SubCategory(name: "BACON"),
            SubCategory(name: "BREAKFAST"),
            SubCategory(name: "CHEESEBURGUER"),
            SubCategory(name: "COFFEE"),
            SubCategory(name: "DOUGHNUT"),
            SubCategory(name: "HOT DOG"),
            SubCategory(name: "ICE CREAM"),
            SubCategory(name: "PIZZA")
            ]),
        Category(name: "GAMING", subCategories: [
            SubCategory(name: "8BIT"),
            SubCategory(name: "BIOSHOCK INFINITE"),
            SubCategory(name: "GAME BOY"),
            SubCategory(name: "GRAND THEFT AUTO"),
            SubCategory(name: "MORTAL KOMBAT"),
            SubCategory(name: "SONIC THE HEDGEHOG"),
            SubCategory(name: "SUPER MARIO"),
            SubCategory(name: "SUPER NINTENDO"),
            SubCategory(name: "THE SIMS")
            ]),
        Category(name: "HOLIDAYS", subCategories: [
            SubCategory(name: "BIRTHDAY"),
            SubCategory(name: "CHRISTMAS"),
            SubCategory(name: "EASTER"),
            SubCategory(name: "FOURTH OF JULY"),
            SubCategory(name: "HALLOWEEN"),
            SubCategory(name: "NEW YEARS"),
            SubCategory(name: "THANKSGIVING"),
            SubCategory(name: "VALENTINES DAY"),
            SubCategory(name: "WEDDING")
            ]),
        Category(name: "INTERESTS", subCategories: [
            SubCategory(name: "BABY"),
            SubCategory(name: "BALLET"),
            SubCategory(name: "INTERNET"),
            SubCategory(name: "IPHONE"),
            SubCategory(name: "THEME PARK"),
            SubCategory(name: "VAMPIRE"),
            SubCategory(name: "WINTER"),
            SubCategory(name: "WORK"),
            SubCategory(name: "ZOMBIE")
            ]),
        Category(name: "MEMES", subCategories: [
            SubCategory(name: "DEAL WITH IT"),
            SubCategory(name: "FANGIRLING"),
            SubCategory(name: "FEELS"),
            SubCategory(name: "LIKE A BOSS"),
            SubCategory(name: "LET ME LOVE YOU"),
            SubCategory(name: "PARTY HARD"),
            SubCategory(name: "SPINNING LANA"),
            SubCategory(name: "STEAL YO GIRL"),
            SubCategory(name: "SURPRISED PATRICK")
            ]),
        Category(name: "MOVIES", subCategories: [
            SubCategory(name: "AMERICAN PSYCHO"),
            SubCategory(name: "ANCHORMAN"),
            SubCategory(name: "HARRY POTTER"),
            SubCategory(name: "KILL BILL"),
            SubCategory(name: "SCARFACE"),
            SubCategory(name: "SPRING BREAKERS"),
            SubCategory(name: "STAR WARS"),
            SubCategory(name: "THE HUNGER GAMES"),
            SubCategory(name: "THE SHINNING")
            ]),
        Category(name: "MUSIC", subCategories: [
            SubCategory(name: "BEYONCE"),
            SubCategory(name: "DAFT PUNK"),
            SubCategory(name: "DAVID BOWIE"),
            SubCategory(name: "JUSTIN BIEBER"),
            SubCategory(name: "KANYE WEST"),
            SubCategory(name: "LANA DEL REY"),
            SubCategory(name: "MILEY CYRUS"),
            SubCategory(name: "ONE DIRECTION"),
            SubCategory(name: "RIHANNA")
            ]),
        Category(name: "NATURE", subCategories: [
            SubCategory(name: "BEACH"),
            SubCategory(name: "CLOUDS"),
            SubCategory(name: "FOREST"),
            SubCategory(name: "LAVA"),
            SubCategory(name: "NORTHERN LIGHTS"),
            SubCategory(name: "OCEAN"),
            SubCategory(name: "SNOW"),
            SubCategory(name: "SUNRISE"),
            SubCategory(name: "WATERFALL")
            ]),
        Category(name: "NEWS & POLITICS", subCategories: [
            SubCategory(name: "BARACK OBAMA"),
            SubCategory(name: "HILLARY CLINTON"),
            SubCategory(name: "JOE BIDEN"),
            SubCategory(name: "NSA"),
            SubCategory(name: "THE COLBERT REPORT")
            ]),
        Category(name: "REACTIONS", subCategories: [
            SubCategory(name: "EYE ROLL"),
            SubCategory(name: "FACEPALM"),
            SubCategory(name: "HAPPY"),
            SubCategory(name: "HIGH FIVE"),
            SubCategory(name: "KISS"),
            SubCategory(name: "LOL"),
            SubCategory(name: "NO"),
            SubCategory(name: "SAD"),
            SubCategory(name: "SHRUG"),
            SubCategory(name: "THUMBS UP"),
            SubCategory(name: "WINK"),
            SubCategory(name: "YES")
            ]),
        Category(name: "SCIENCE", subCategories: [
            SubCategory(name: "BILL NYE"),
            SubCategory(name: "BIOLOGY"),
            SubCategory(name: "BUBBLES"),
            SubCategory(name: "COMPUTER"),
            SubCategory(name: "MAGNETS"),
            SubCategory(name: "MATHEMATICS"),
            SubCategory(name: "NASA"),
            SubCategory(name: "ROBOT"),
            SubCategory(name: "SPACE")
            ]),
        Category(name: "SPORTS", subCategories: [
            SubCategory(name: "BASEBALL"),
            SubCategory(name: "BASKETBALL"),
            SubCategory(name: "GYMNASTICS"),
            SubCategory(name: "MMA"),
            SubCategory(name: "NFL"),
            SubCategory(name: "SKATEBOARDING"),
            SubCategory(name: "SNOWBOARDING"),
            SubCategory(name: "SURFING"),
            SubCategory(name: "WRESTLING")
            ]),
        Category(name: "TRANSPORTATION", subCategories: [
            SubCategory(name: "AUDI"),
            SubCategory(name: "BMW"),
            SubCategory(name: "FERRARI"),
            SubCategory(name: "LAMBORGHINI"),
            SubCategory(name: "MOTORCYCLE"),
            SubCategory(name: "NISSAN"),
            SubCategory(name: "PORSCHE"),
            SubCategory(name: "SUBWAY"),
            SubCategory(name: "TANK")
            ]),
        Category(name: "TV", subCategories: [
            SubCategory(name: "ARRESTED DEVELOPMENT"),
            SubCategory(name: "BREAKING BAD"),
            SubCategory(name: "GAME OF THRONES"),
            SubCategory(name: "HOUSE OF CARDS"),
            SubCategory(name: "INFOMERCIAL"),
            SubCategory(name: "MAD MEN"),
            SubCategory(name: "NEW GIRL"),
            SubCategory(name: "PARKS AND RECREATION"),
            SubCategory(name: "SHERLOCK"),
            SubCategory(name: "WORKAHOLICS")
            ])
    ]
}