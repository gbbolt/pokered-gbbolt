SECTION "Text 1", ROMX

;@ path: data/text/text_1
_CardKeySuccessText1::
	db TX_START, "Bingo!@"
	db TX_END

;@ path: data/text/text_1
_CardKeySuccessText2::
	db TX_START
	db "<LINE>", "The CARD KEY"
	db "<CONT>", "opened the door!"
	db "<DONE>"

;@ path: data/text/text_1
_CardKeyFailText::
	db TX_START, "Darn! It needs a"
	db "<LINE>", "CARD KEY!"
	db "<DONE>"

;@ path: data/text/text_1
_TrainerNameText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, ": @"
	db TX_END

;@ path: data/text/text_1
_NoNibbleText::
	db TX_START, "Not even a nibble!"
	db "<PROMPT>"

;@ path: data/text/text_1
_NothingHereText::
	db TX_START, "Looks like there's"
	db "<LINE>", "nothing here."
	db "<PROMPT>"

;@ path: data/text/text_1
_ItsABiteText::
	db TX_START, "Oh!"
	db "<LINE>", "It's a bite!"
	db "<PROMPT>"

;@ path: data/text/text_1
_ExclamationText::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_1
_GroundRoseText::
	db TX_START, "Ground rose up"
	db "<LINE>", "somewhere!"
	db "<DONE>"

;@ path: data/text/text_1
_BoulderText::
	db TX_START, "This requires"
	db "<LINE>", "STRENGTH to move!"
	db "<DONE>"

;@ path: data/text/text_1
_MartSignText::
	db TX_START, "All your item"
	db "<LINE>", "needs fulfilled!"
	db "<CONT>", "#MON MART"
	db "<DONE>"

;@ path: data/text/text_1
_PokeCenterSignText::
	db TX_START, "Heal Your #MON!"
	db "<LINE>", "#MON CENTER"
	db "<DONE>"

;@ path: data/text/text_1
_FoundItemText::
	db TX_START, "<PLAYER> found"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_1
_NoMoreRoomForItemText::
	db TX_START, "No more room for"
	db "<LINE>", "items!"
	db "<DONE>"

;@ path: data/text/text_1
_OaksAideHiText::
	db TX_START, "Hi! Remember me?"
	db "<LINE>", "I'm PROF.OAK's"
	db "<CONT>", "AIDE!"

	db "<PARA>", "If you caught @"
	db TX_NUM
	dw hOaksAideRequirement
	db ((1) << 4) | (3)
	db TX_START
	db "<LINE>", "kinds of #MON,"
	db "<CONT>", "I'm supposed to"
	db "<CONT>", "give you an"
	db "<CONT>", "@"
	db TX_RAM
	dw wOaksAideRewardItemName
	db TX_START, "!"

	db "<PARA>", "So, <PLAYER>! Have"
	db "<LINE>", "you caught at"
	db "<CONT>", "least @"
	db TX_NUM
	dw hOaksAideRequirement
	db ((1) << 4) | (3)
	db TX_START, " kinds of"
	db "<CONT>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_1
_OaksAideUhOhText::
	db TX_START, "Let's see..."
	db "<LINE>", "Uh-oh! You have"
	db "<CONT>", "caught only @"
	db TX_NUM
	dw hOaksAideNumMonsOwned
	db ((1) << 4) | (3)
	db TX_START
	db "<CONT>", "kinds of #MON!"

	db "<PARA>", "You need @"
	db TX_NUM
	dw hOaksAideRequirement
	db ((1) << 4) | (3)
	db TX_START, " kinds"
	db "<LINE>", "if you want the"
	db "<CONT>", "@"
	db TX_RAM
	dw wOaksAideRewardItemName
	db TX_START, "."
	db "<DONE>"

;@ path: data/text/text_1
_OaksAideComeBackText::
	db TX_START, "Oh. I see."

	db "<PARA>", "When you get @"
	db TX_NUM
	dw hOaksAideRequirement
	db ((1) << 4) | (3)
	db TX_START
	db "<LINE>", "kinds, come back"
	db "<CONT>", "for @"
	db TX_RAM
	dw wOaksAideRewardItemName
	db TX_START, "."
	db "<DONE>"

;@ path: data/text/text_1
_OaksAideHereYouGoText::
	db TX_START, "Great! You have"
	db "<LINE>", "caught @"
	db TX_NUM
	dw hOaksAideNumMonsOwned
	db ((1) << 4) | (3)
	db TX_START, " kinds "
	db "<CONT>", "of #MON!"
	db "<CONT>", "Congratulations!"

	db "<PARA>", "Here you go!"
	db "<PROMPT>"

;@ path: data/text/text_1
_OaksAideGotItemText::
	db TX_START, "<PLAYER> got the"
	db "<LINE>", "@"
	db TX_RAM
	dw wOaksAideRewardItemName
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_1
_OaksAideNoRoomText::
	db TX_START, "Oh! I see you"
	db "<LINE>", "don't have any"
	db "<CONT>", "room for the"
	db "<CONT>", "@"
	db TX_RAM
	dw wOaksAideRewardItemName
	db TX_START, "."
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster1Text::
	db TX_START, "I came here with"
	db "<LINE>", "some friends!"

	db "<PARA>", "They're out for"
	db "<LINE>", "#MON fights!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster2BattleText::
	db TX_START, "Hey! You have"
	db "<LINE>", "#MON! Come on!"
	db "<CONT>", "Let's battle'em!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster2EndBattleText::
	db TX_START, "No!"
	db "<LINE>", "CATERPIE can't"
	db "<CONT>", "cut it!"
	db "<PROMPT>"

;@ path: text/ViridianForest
_ViridianForestYoungster2AfterBattleText::
	db TX_START, "Ssh! You'll scare"
	db "<LINE>", "the bugs away!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster3BattleText::
	db TX_START, "Yo! You can't jam"
	db "<LINE>", "out if you're a"
	db "<CONT>", "#MON trainer!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster3EndBattleText::
	db TX_START, "Huh?"
	db "<LINE>", "I ran out of"
	db "<CONT>", "#MON!"
	db "<PROMPT>"

;@ path: text/ViridianForest
_ViridianForestYoungster3AfterBattleText::
	db TX_START, "Darn! I'm going"
	db "<LINE>", "to catch some"
	db "<CONT>", "stronger ones!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster4BattleText::
	db TX_START, "Hey, wait up!"
	db "<LINE>", "What's the hurry?"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster4EndBattleText::
	db TX_START, "I"
	db "<LINE>", "give! You're good"
	db "<CONT>", "at this!"
	db "<PROMPT>"

;@ path: text/ViridianForest
_ViridianForestYoungster4AfterBattleText::
	db TX_START, "Sometimes, you"
	db "<LINE>", "can find stuff on"
	db "<CONT>", "the ground!"

	db "<PARA>", "I'm looking for"
	db "<LINE>", "the stuff I"
	db "<CONT>", "dropped!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestYoungster5Text::
	db TX_START, "I ran out of #"
	db "<LINE>", "BALLs to catch"
	db "<CONT>", "#MON with!"

	db "<PARA>", "You should carry"
	db "<LINE>", "extras!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestTrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "If you want to"
	db "<LINE>", "avoid battles,"
	db "<CONT>", "stay away from"
	db "<CONT>", "grassy areas!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestUseAntidoteSignText::
	db TX_START, "For poison, use"
	db "<LINE>", "ANTIDOTE! Get it"
	db "<CONT>", "at #MON MARTs!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestTrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Contact PROF.OAK"
	db "<LINE>", "via PC to get"
	db "<CONT>", "your #DEX"
	db "<CONT>", "evaluated!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestTrainerTips3Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "No stealing of"
	db "<LINE>", "#MON from"
	db "<CONT>", "other trainers!"
	db "<CONT>", "Catch only wild"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestTrainerTips4Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Weaken #MON"
	db "<LINE>", "before attempting"
	db "<CONT>", "capture!"

	db "<PARA>", "When healthy,"
	db "<LINE>", "they may escape!"
	db "<DONE>"

;@ path: text/ViridianForest
_ViridianForestLeavingSignText::
	db TX_START, "LEAVING"
	db "<LINE>", "VIRIDIAN FOREST"
	db "<CONT>", "PEWTER CITY AHEAD"
	db "<DONE>"
;@ path: text/MtMoon1F
_MtMoon1FHikerBattleText::
	db TX_START, "WHOA! You shocked"
	db "<LINE>", "me! Oh, you're"
	db "<CONT>", "just a kid!"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FHikerEndBattleText::
	db TX_START, "Wow!"
	db "<LINE>", "Shocked again!"
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FHikerAfterBattleText::
	db TX_START, "Kids like you"
	db "<LINE>", "shouldn't be"
	db "<CONT>", "here!"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster1BattleText::
	db TX_START, "Did you come to"
	db "<LINE>", "explore too?"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster1EndBattleText::
	db TX_START, "Losing"
	db "<LINE>", "stinks!"
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster1AfterBattleText::
	db TX_START, "I came down here"
	db "<LINE>", "to show off to"
	db "<CONT>", "girls."
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FCooltrainerF1BattleText::
	db TX_START, "Wow! It's way"
	db "<LINE>", "bigger in here"
	db "<CONT>", "than I thought!"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FCooltrainerF1EndBattleText::
	db TX_START, "Oh!"
	db "<LINE>", "I lost it!"
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FCooltrainerF1AfterBattleText::
	db TX_START, "How do you get"
	db "<LINE>", "out of here?"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FSuperNerdBattleText::
	db TX_START, "What! Don't sneak"
	db "<LINE>", "up on me!"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FSuperNerdEndBattleText::
	db TX_START, "My"
	db "<LINE>", "#MON won't do!"
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FSuperNerdAfterBattleText::
	db TX_START, "I have to find"
	db "<LINE>", "stronger #MON."
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FCooltrainerF2BattleText::
	db TX_START, "What? I'm waiting"
	db "<LINE>", "for my friends to"
	db "<CONT>", "find me here."
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FCooltrainerF2EndBattleText::
	db TX_START, "I lost?"
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FCooltrainerF2AfterBattleText::
	db TX_START, "I heard there are"
	db "<LINE>", "some very rare"
	db "<CONT>", "fossils here."
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster2BattleText::
	db TX_START, "Suspicious men"
	db "<LINE>", "are in the cave."
	db "<CONT>", "What about you?"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster2EndBattleText::
	db TX_START, "You"
	db "<LINE>", "got me!"
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster2AfterBattleText::
	db TX_START, "I saw them! I'm"
	db "<LINE>", "sure they're from"
	db "<CONT>", "TEAM ROCKET!"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster3BattleText::
	db TX_START, "Go through this"
	db "<LINE>", "cave to get to"
	db "<CONT>", "CERULEAN CITY!"
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster3EndBattleText::
	db TX_START, "I"
	db "<LINE>", "lost."
	db "<PROMPT>"

;@ path: text/MtMoon1F
_MtMoon1FYoungster3AfterBattleText::
	db TX_START, "ZUBAT is tough!"
	db "<LINE>", "But, it can be"
	db "<CONT>", "useful if you"
	db "<CONT>", "catch one."
	db "<DONE>"

;@ path: text/MtMoon1F
_MtMoon1FBewareZubatSign::
	db TX_START, "Beware! ZUBAT is"
	db "<LINE>", "a blood sucker!"
	db "<DONE>"
;@ path: text/MtMoonB1F
_MtMoonB1FUnusedText::
	db TX_START
	db "<DONE>"
;@ path: text/MtMoonB2F
_MtMoonB2FDomeFossilYouWantText::
	db TX_START, "You want the"
	db "<LINE>", "DOME FOSSIL?"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FHelixFossilYouWantText::
	db TX_START, "You want the"
	db "<LINE>", "HELIX FOSSIL?"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FReceivedFossilText::
	db TX_START, "<PLAYER> got the"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/MtMoonB2F
_MtMoonB2FYouHaveNoRoomText::
	db TX_START, "Look, you've got"
	db "<LINE>", "no room for this.@"
	db TX_END

;@ path: text/MtMoonB2F
_MtMoonB2FSuperNerdTheyreBothMineText::
	db TX_START, "Hey, stop!"

	db "<PARA>", "I found these"
	db "<LINE>", "fossils! They're"
	db "<CONT>", "both mine!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FSuperNerdOkIllShareText::
	db TX_START, "OK!"
	db "<LINE>", "I'll share!"
	db "<PROMPT>"

;@ path: text/MtMoonB2F
_MtMoonB2fSuperNerdEachTakeOneText::
	db TX_START, "We'll each take"
	db "<LINE>", "one!"
	db "<CONT>", "No being greedy!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FSuperNerdTheresAPokemonLabText::
	db TX_START, "Far away, on"
	db "<LINE>", "CINNABAR ISLAND,"
	db "<CONT>", "there's a #MON"
	db "<CONT>", "LAB."

	db "<PARA>", "They do research"
	db "<LINE>", "on regenerating"
	db "<CONT>", "fossils."
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FSuperNerdThenThisIsMineText::
	db TX_START, "All right. Then"
	db "<LINE>", "this is mine!@"
	db TX_END

;@ path: text/MtMoonB2F
_MtMoonB2FRocket1BattleText::
	db TX_START, "TEAM ROCKET will"
	db "<LINE>", "find the fossils,"
	db "<CONT>", "revive and sell"
	db "<CONT>", "them for cash!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket1EndBattleText::
	db TX_START, "Urgh!"
	db "<LINE>", "Now I'm mad!"
	db "<PROMPT>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket1AfterBattleText::
	db TX_START, "You made me mad!"
	db "<LINE>", "TEAM ROCKET will"
	db "<CONT>", "blacklist you!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket2BattleText::
	db TX_START, "We, TEAM ROCKET,"
	db "<LINE>", "are #MON"
	db "<CONT>", "gangsters!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket2EndBattleText::
	db TX_START, "I blew"
	db "<LINE>", "it!"
	db "<PROMPT>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket2AfterBattleText::
	db TX_START, "Darn it all! My"
	db "<LINE>", "associates won't"
	db "<CONT>", "stand for this!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket3BattleText::
	db TX_START, "We're pulling a"
	db "<LINE>", "big job here!"
	db "<CONT>", "Get lost, kid!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket3EndBattleText::
	db TX_START, "So, you"
	db "<LINE>", "are good."
	db "<PROMPT>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket3AfterBattleText::
	db TX_START, "If you find a"
	db "<LINE>", "fossil, give it"
	db "<CONT>", "to me and scram!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket4BattleText::
	db TX_START, "Little kids"
	db "<LINE>", "should leave"
	db "<CONT>", "grown-ups alone!"
	db "<DONE>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket4EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "steamed!"
	db "<PROMPT>"

;@ path: text/MtMoonB2F
_MtMoonB2FRocket4AfterBattleText::
	db TX_START, "#MON lived"
	db "<LINE>", "here long before"
	db "<CONT>", "people came."
	db "<DONE>"
;@ path: text/SSAnne1F
_SSAnne1FWaiterText::
	db TX_START, "Bonjour!"
	db "<LINE>", "I am le waiter on"
	db "<CONT>", "this ship!"

	db "<PARA>", "I will be happy"
	db "<LINE>", "to serve you any-"
	db "<CONT>", "thing you please!"

	db "<PARA>", "Ah! Le strong"
	db "<LINE>", "silent type!"
	db "<DONE>"

;@ path: text/SSAnne1F
_SSAnne1FSailorText::
	db TX_START, "The passengers"
	db "<LINE>", "are restless!"

	db "<PARA>", "You might be"
	db "<LINE>", "challenged by the"
	db "<CONT>", "more bored ones!"
	db "<DONE>"
;@ path: text/SSAnne2F
_SSAnne2FWaiterText::
	db TX_START, "This ship, she is"
	db "<LINE>", "a luxury liner"
	db "<CONT>", "for trainers!"

	db "<PARA>", "At every port, we"
	db "<LINE>", "hold parties with"
	db "<CONT>", "invited trainers!"
	db "<DONE>"

;@ path: text/SSAnne2F
_SSAnne2FRivalText::
	db TX_START, "<RIVAL>: Bonjour!"
	db "<LINE>", "<PLAYER>!"

	db "<PARA>", "Imagine seeing"
	db "<LINE>", "you here!"

	db "<PARA>", "<PLAYER>, were you"
	db "<LINE>", "really invited?"

	db "<PARA>", "So how's your"
	db "<LINE>", "#DEX coming?"

	db "<PARA>", "I already caught"
	db "<LINE>", "40 kinds, pal!"

	db "<PARA>", "Different kinds"
	db "<LINE>", "are everywhere!"

	db "<PARA>", "Crawl around in"
	db "<LINE>", "grassy areas!"
	db "<DONE>"

;@ path: text/SSAnne2F
_SSAnne2FRivalDefeatedText::
	db TX_START, "Humph!"

	db "<PARA>", "At least you're"
	db "<LINE>", "raising your"
	db "<CONT>", "#MON!"
	db "<PROMPT>"

;@ path: text/SSAnne2F
_SSAnne2FRivalVictoryText::
	db TX_START, "<PLAYER>! What are"
	db "<LINE>", "you, seasick?"

	db "<PARA>", "You should shape"
	db "<LINE>", "up, pal!"
	db "<PROMPT>"

;@ path: text/SSAnne2F
_SSAnne2FRivalCutMasterText::
	db TX_START, "<RIVAL>: I heard"
	db "<LINE>", "there was a CUT"
	db "<CONT>", "master on board."

	db "<PARA>", "But, he was just a"
	db "<LINE>", "seasick, old man!"

	db "<PARA>", "But, CUT itself is"
	db "<LINE>", "really useful!"

	db "<PARA>", "You should go see"
	db "<LINE>", "him! Smell ya!"
	db "<DONE>"
;@ path: text/SSAnne3F
_SSAnne3FSailorText::
	db TX_START, "Our CAPTAIN is a"
	db "<LINE>", "sword master!"

	db "<PARA>", "He even teaches"
	db "<LINE>", "CUT to #MON!"
	db "<DONE>"
;@ path: text/SSAnneBow
_SSAnneBowSuperNerdText::
	db TX_START, "The party's over."
	db "<LINE>", "The ship will be"
	db "<CONT>", "departing soon."
	db "<DONE>"

;@ path: text/SSAnneBow
_SSAnneBowSailor1Text::
	db TX_START, "Scrubbing decks"
	db "<LINE>", "is hard work!"
	db "<DONE>"

;@ path: text/SSAnneBow
_SSAnneBowCooltrainerMText::
	db TX_START, "Urf. I feel ill."

	db "<PARA>", "I stepped out to"
	db "<LINE>", "get some air."
	db "<DONE>"

;@ path: text/SSAnneBow
_SSAnneBowSailor2BattleText::
	db TX_START, "Hey matey!"

	db "<PARA>", "Let's do a little"
	db "<LINE>", "jig!"
	db "<DONE>"

;@ path: text/SSAnneBow
_SSAnneBowSailor2EndBattleText::
	db TX_START, "You're"
	db "<LINE>", "impressive!"
	db "<PROMPT>"

;@ path: text/SSAnneBow
_SSAnneBowSailor2AfterBattleText::
	db TX_START, "How many kinds of"
	db "<LINE>", "#MON do you"
	db "<CONT>", "think there are?"
	db "<DONE>"

;@ path: text/SSAnneBow
_SSAnneBowSailor3BattleText::
	db TX_START, "Ahoy there!"
	db "<LINE>", "Are you seasick?"
	db "<DONE>"

;@ path: text/SSAnneBow
_SSAnneBowSailor3EndBattleText::
	db TX_START, "I was"
	db "<LINE>", "just careless!"
	db "<PROMPT>"

;@ path: text/SSAnneBow
_SSAnneBowSailor3AfterBattleText::
	db TX_START, "My Pa said there"
	db "<LINE>", "are 100 kinds of"
	db "<CONT>", "#MON. I think"
	db "<CONT>", "there are more."
	db "<DONE>"
;@ path: text/SSAnneKitchen
_SSAnneKitchenCook1Text::
	db TX_START, "You, mon petit!"
	db "<LINE>", "We're busy here!"
	db "<CONT>", "Out of the way!"
	db "<DONE>"

;@ path: text/SSAnneKitchen
_SSAnneKitchenCook2Text::
	db TX_START, "I saw an odd ball"
	db "<LINE>", "in the trash."
	db "<DONE>"

;@ path: text/SSAnneKitchen
_SSAnneKitchenCook3Text::
	db TX_START, "I'm so busy I'm"
	db "<LINE>", "getting dizzy!"
	db "<DONE>"

;@ path: text/SSAnneKitchen
_SSAnneKitchenCook4Text::
	db TX_START, "Hum-de-hum-de-"
	db "<LINE>", "ho..."

	db "<PARA>", "I peel spuds"
	db "<LINE>", "every day!"
	db "<CONT>", "Hum-hum..."
	db "<DONE>"

;@ path: text/SSAnneKitchen
_SSAnneKitchenCook5Text::
	db TX_START, "Did you hear about"
	db "<LINE>", "SNORLAX?"

	db "<PARA>", "All it does is"
	db "<LINE>", "eat and sleep!"
	db "<DONE>"

;@ path: text/SSAnneKitchen
_SSAnneKitchenCook6Text::
	db TX_START, "Snivel...Sniff..."

	db "<PARA>", "I only get to"
	db "<LINE>", "peel onions..."
	db "<CONT>", "Snivel..."
	db "<DONE>"

;@ path: text/SSAnneKitchen
_SSAnneKitchenCook7MainCourseIsText::
	db TX_START, "Er-hem! Indeed I"
	db "<LINE>", "am le CHEF!"

	db "<PARA>", "Le main course is"
	db "<PROMPT>"

;@ path: text/SSAnneKitchen
SSAnneKitchenCook7SalmonDuSaladText::
	db TX_START, "Salmon du Salad!"

	db "<PARA>", "Les guests may"
	db "<LINE>", "gripe it's fish"
	db "<CONT>", "again, however!"
	db "<DONE>"

;@ path: text/SSAnneKitchen
SSAnneKitchenCook7EelsAuBarbecueText::
	db TX_START, "Eels au Barbecue!"

	db "<PARA>", "Les guests will"
	db "<LINE>", "mutiny, I fear."
	db "<DONE>"

;@ path: text/SSAnneKitchen
SSAnneKitchenCook7PrimeBeefSteakText::
	db TX_START, "Prime Beef Steak!"

	db "<PARA>", "But, have I enough"
	db "<LINE>", "fillets du beef?"
	db "<DONE>"
;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomRubCaptainsBackText::
	db TX_START, "CAPTAIN: Ooargh..."
	db "<LINE>", "I feel hideous..."
	db "<CONT>", "Urrp! Seasick..."

	db "<PARA>", "<PLAYER> rubbed"
	db "<LINE>", "the CAPTAIN's"
	db "<CONT>", "back!"

	db "<PARA>", "Rub-rub..."
	db "<LINE>", "Rub-rub...@"
	db TX_END

;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomCaptainIFeelMuchBetterText::
	db TX_START, "CAPTAIN: Whew!"
	db "<LINE>", "Thank you! I"
	db "<CONT>", "feel much better!"

	db "<PARA>", "You want to see"
	db "<LINE>", "my CUT technique?"

	db "<PARA>", "I could show you"
	db "<LINE>", "if I wasn't ill..."

	db "<PARA>", "I know! You can"
	db "<LINE>", "have this!"

	db "<PARA>", "Teach it to your"
	db "<LINE>", "#MON and you"
	db "<CONT>", "can see it CUT"
	db "<CONT>", "any time!"
	db "<PROMPT>"

;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomCaptainReceivedHM01Text::
	db TX_START, "<PLAYER> got"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomCaptainNotSickAnymoreText::
	db TX_START, "CAPTAIN: Whew!"

	db "<PARA>", "Now that I'm not"
	db "<LINE>", "sick any more, I"
	db "<CONT>", "guess it's time."
	db "<DONE>"

;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomCaptainHM01NoRoomText::
	db TX_START, "Oh no! You have"
	db "<LINE>", "no room for this!"
	db "<DONE>"

;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomTrashText::
	db TX_START, "Yuck! Shouldn't"
	db "<LINE>", "have looked!"
	db "<DONE>"

;@ path: text/SSAnneCaptainsRoom
_SSAnneCaptainsRoomSeasickBookText::
	db TX_START, "How to Conquer"
	db "<LINE>", "Seasickness..."
	db "<CONT>", "The CAPTAIN's"
	db "<CONT>", "reading this!"
	db "<DONE>"
;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsWigglytuffText::
	db TX_START, "WIGGLYTUFF: Puup"
	db "<LINE>", "pupuu!@"
	db TX_END

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman1BattleText::
	db TX_START, "I travel alone"
	db "<LINE>", "on my journeys!"

	db "<PARA>", "My #MON are my"
	db "<LINE>", "only friends!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman1EndBattleText::
	db TX_START, "My, my"
	db "<LINE>", "friends..."
	db "<PROMPT>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman1AfterBattleText::
	db TX_START, "You should be"
	db "<LINE>", "nice to friends!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman2BattleText::
	db TX_START, "You pup! How dare"
	db "<LINE>", "you barge in!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman2EndBattleText::
	db TX_START, "Humph!"
	db "<LINE>", "You rude child!"
	db "<PROMPT>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman2AfterBattleText::
	db TX_START, "I wish to be left"
	db "<LINE>", "alone! Get out!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsYoungsterBattleText::
	db TX_START, "I love #MON!"
	db "<LINE>", "Do you?"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsYoungsterEndBattleText::
	db TX_START, "Wow! "
	db "<LINE>", "You're great!"
	db "<PROMPT>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsYoungsterAfterBattleText::
	db TX_START, "Let me be your"
	db "<LINE>", "friend, OK?"

	db "<PARA>", "Then we can trade"
	db "<LINE>", "#MON!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsCooltrainerFBattleText::
	db TX_START, "I collected these"
	db "<LINE>", "#MON from all"
	db "<CONT>", "around the world!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsCooltrainerFEndBattleText::
	db TX_START, "Oh no!"
	db "<LINE>", "I went around the"
	db "<CONT>", "world for these!"
	db "<PROMPT>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsCooltrainerFAfterBattleText::
	db TX_START, "You hurt my poor"
	db "<LINE>", "worldly #MON!"

	db "<PARA>", "I demand that you"
	db "<LINE>", "heal them at a"
	db "<CONT>", "#MON CENTER!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGirl1Text::
	db TX_START, "Waiter, I would"
	db "<LINE>", "like a cherry pie"
	db "<CONT>", "please!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsMiddleAgedManText::
	db TX_START, "A cruise is so"
	db "<LINE>", "elegant yet cozy!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsLittleGirlText::
	db TX_START, "I always travel"
	db "<LINE>", "with WIGGLYTUFF!"
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGirl2Text::
	db TX_START, "We are cruising"
	db "<LINE>", "around the world."
	db "<DONE>"

;@ path: text/SSAnne1FRooms
_SSAnne1FRoomsGentleman3Text::
	db TX_START, "Ssh! I'm a GLOBAL"
	db "<LINE>", "POLICE agent!"

	db "<PARA>", "I'm on the trail"
	db "<LINE>", "of TEAM ROCKET!"
	db "<DONE>"
;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman3Text::
	db TX_START, "In all my travels"
	db "<LINE>", "I've never seen"
	db "<CONT>", "any #MON sleep"
	db "<CONT>", "like this one!"

	db "<PARA>", "It was something"
	db "<LINE>", "like this!"
	db "<PROMPT>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman4Text::
	db TX_START, "Ah yes, I have"
	db "<LINE>", "seen some #MON"
	db "<CONT>", "ferry people"
	db "<CONT>", "across the water!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGrampsText::
	db TX_START, "#MON can CUT"
	db "<LINE>", "down small bushes."
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman5Text::
	db TX_START, "Have you gone to"
	db "<LINE>", "the SAFARI ZONE"
	db "<CONT>", "in FUCHSIA CITY?"

	db "<PARA>", "It had many rare"
	db "<LINE>", "kinds of #MON!!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsLittleBoyText::
	db TX_START, "Me and my Daddy"
	db "<LINE>", "think the SAFARI"
	db "<CONT>", "ZONE is awesome!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsBrunetteGirlText::
	db TX_START, "The CAPTAIN looked"
	db "<LINE>", "really sick and"
	db "<CONT>", "pale!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsBeautyText::
	db TX_START, "I hear many people"
	db "<LINE>", "get seasick!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman1BattleText::
	db TX_START, "Competing against"
	db "<LINE>", "the young keeps"
	db "<CONT>", "me youthful."
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman1EndBattleText::
	db TX_START, "Good"
	db "<LINE>", "fight! Ah, I feel"
	db "<CONT>", "young again!"
	db "<PROMPT>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman1AfterBattleText::
	db TX_START, "15 years ago, I"
	db "<LINE>", "would have won!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsFisherBattleText::
	db TX_START, "Check out what I"
	db "<LINE>", "fished up!"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsFisherEndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "all out!"
	db "<PROMPT>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsFisherAfterBattleText::
	db TX_START, "Party?"

	db "<PARA>", "The cruise ship's"
	db "<LINE>", "party should be"
	db "<CONT>", "over by now."
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman2BattleText::
	db TX_START, "Which do you like,"
	db "<LINE>", "a strong or a"
	db "<CONT>", "rare #MON?"
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman2EndBattleText::
	db TX_START, "I must"
	db "<LINE>", "salute you!"
	db "<PROMPT>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsGentleman2AfterBattleText::
	db TX_START, "I prefer strong"
	db "<LINE>", "and rare #MON."
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsCooltrainerFBattleText::
	db TX_START, "I never saw you"
	db "<LINE>", "at the party."
	db "<DONE>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsCooltrainerFEndBattleText::
	db TX_START, "Take"
	db "<LINE>", "it easy!"
	db "<PROMPT>"

;@ path: text/SSAnne2FRooms
_SSAnne2FRoomsCooltrainerFAfterBattleText::
	db TX_START, "Oh, I adore your"
	db "<LINE>", "strong #MON!"
	db "<DONE>"
;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsMachokeText::
	db TX_START, "MACHOKE: Gwoh!"
	db "<LINE>", "Goggoh!@"
	db TX_END

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor1BattleText::
	db TX_START, "You know what they"
	db "<LINE>", "say about sailors"
	db "<CONT>", "and fighting!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor1EndBattleText::
	db TX_START, "Right!"
	db "<LINE>", "Good fight, mate!"
	db "<PROMPT>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor1AfterBattleText::
	db TX_START, "Haha! Want to be"
	db "<LINE>", "a sailor, mate?"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor2BattleText::
	db TX_START, "My sailor's pride"
	db "<LINE>", "is at stake!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor2EndBattleText::
	db TX_START, "Your"
	db "<LINE>", "spirit sank me!"
	db "<PROMPT>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor2AfterBattleText::
	db TX_START, "Did you see the"
	db "<LINE>", "FISHING GURU in"
	db "<CONT>", "VERMILION CITY?"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor3BattleText::
	db TX_START, "Us sailors have"
	db "<LINE>", "#MON too!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor3EndBattleText::
	db TX_START, "OK, "
	db "<LINE>", "you're not bad."
	db "<PROMPT>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor3AfterBattleText::
	db TX_START, "We caught all our"
	db "<LINE>", "#MON while"
	db "<CONT>", "out at sea!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor4BattleText::
	db TX_START, "I like feisty"
	db "<LINE>", "kids like you!@"
	db TX_END

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor4EndBattleText::
	db TX_START, "Argh!"
	db "<LINE>", "Lost it!"
	db "<PROMPT>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor4AfterBattleText::
	db TX_START, "Sea #MON live"
	db "<LINE>", "in deep water."
	db "<CONT>", "You'll need a ROD!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor5BattleText::
	db TX_START, "Matey, you're"
	db "<LINE>", "walking the plank"
	db "<CONT>", "if you lose!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor5EndBattleText::
	db TX_START, "Argh!"
	db "<LINE>", "Beaten by a kid!"
	db "<PROMPT>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSailor5AfterBattleText::
	db TX_START, "Jellyfish some-"
	db "<LINE>", "times drift into"
	db "<CONT>", "the ship."
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsFisherBattleText::
	db TX_START, "Hello stranger!"
	db "<LINE>", "Stop and chat!"

	db "<PARA>", "All my #MON"
	db "<LINE>", "are from the sea!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsFisherEndBattleText::
	db TX_START, "Darn!"
	db "<LINE>", "I let that one"
	db "<CONT>", "get away!"
	db "<PROMPT>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsFisherAfterBattleText::
	db TX_START, "I was going to"
	db "<LINE>", "make you my"
	db "<CONT>", "assistant too!"
	db "<DONE>"

;@ path: text/SSAnneB1FRooms
_SSAnneB1FRoomsSuperNerdText::
	db TX_START, "My buddy, MACHOKE,"
	db "<LINE>", "is super strong!"

	db "<PARA>", "He has enough"
	db "<LINE>", "STRENGTH to move"
	db "<CONT>", "big rocks!"
	db "<DONE>"
;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerM1BattleText::
	db TX_START, "I heard rumors of"
	db "<LINE>", "a child prodigy!"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerM1EndBattleText::
	db TX_START, "The"
	db "<LINE>", "rumors were true!"
	db "<PROMPT>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerM1AfterBattleText::
	db TX_START, "You beat GIOVANNI"
	db "<LINE>", "of TEAM ROCKET?"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerF1BattleText::
	db TX_START, "I'll show you just"
	db "<LINE>", "how good you are!"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerF1EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "furious!"
	db "<PROMPT>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerF1AfterBattleText::
	db TX_START, "You showed me just"
	db "<LINE>", "how good I was!"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerM2BattleText::
	db TX_START, "Only the chosen"
	db "<LINE>", "can pass here!"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerM2EndBattleText::
	db TX_START, "I"
	db "<LINE>", "don't believe it!"
	db "<PROMPT>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerM2AfterBattleText::
	db TX_START, "All trainers here"
	db "<LINE>", "are headed to the"
	db "<CONT>", "#MON LEAGUE!"
	db "<CONT>", "Be careful!"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerF2BattleText::
	db TX_START, "Trainers live to"
	db "<LINE>", "seek stronger"
	db "<CONT>", "opponents!"
	db "<DONE>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerF2EndBattleText::
	db TX_START, "Oh!"
	db "<LINE>", "So strong!"
	db "<PROMPT>"

;@ path: text/VictoryRoad3F
_VictoryRoad3FCooltrainerF2AfterBattleText::
	db TX_START, "By fighting tough"
	db "<LINE>", "battles, you get"
	db "<CONT>", "stronger!"
	db "<DONE>"
;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket5EndBattleText::
	db TX_START, "Why...?@"
	db TX_END

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket1BattleText::
	db TX_START, "Who are you? How"
	db "<LINE>", "did you get here?"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket1EndBattleText::
	db TX_START, "Oww!"
	db "<LINE>", "Beaten!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket1AfterBattleText::
	db TX_START, "Are you dissing"
	db "<LINE>", "TEAM ROCKET?"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket2BattleText::
	db TX_START, "You broke into"
	db "<LINE>", "our operation?"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket2EndBattleText::
	db TX_START, "Burnt!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket2AfterBattleText::
	db TX_START, "You're not going"
	db "<LINE>", "to get away with"
	db "<CONT>", "this, brat!"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket3BattleText::
	db TX_START, "Intruder alert!"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket3EndBattleText::
	db TX_START, "I"
	db "<LINE>", "can't do it!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket3AfterBattleText::
	db TX_START, "SILPH SCOPE?"
	db "<LINE>", "I don't know"
	db "<CONT>", "where it is!"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket4BattleText::
	db TX_START, "Why did you come"
	db "<LINE>", "here?"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket4EndBattleText::
	db TX_START, "This"
	db "<LINE>", "won't do!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket4AfterBattleText::
	db TX_START, "OK, I'll talk!"
	db "<LINE>", "Take the elevator"
	db "<CONT>", "to see my BOSS!"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket5BattleText::
	db TX_START, "Are you lost, you"
	db "<LINE>", "little rat?"
	db "<DONE>"

;@ path: text/RocketHideoutB1F
_RocketHideoutB1FRocket5AfterBattleText::
	db TX_START, "Uh-oh, that fight"
	db "<LINE>", "opened the door!"
	db "<DONE>"
;@ path: text/RocketHideoutB2F
_RocketHideoutB2FRocketBattleText::
	db TX_START, "BOSS said you can"
	db "<LINE>", "see GHOSTs with"
	db "<CONT>", "the SILPH SCOPE!"
	db "<DONE>"

;@ path: text/RocketHideoutB2F
_RocketHideoutB2FRocketEndBattleText::
	db TX_START, "I"
	db "<LINE>", "surrender!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB2F
_RocketHideoutB2FRocketAfterBattleText::
	db TX_START, "The TEAM ROCKET"
	db "<LINE>", "HQ has 4 basement"
	db "<CONT>", "floors. Can you"
	db "<CONT>", "reach the BOSS?"
	db "<DONE>"
;@ path: text/RocketHideoutB3F
_RocketHideoutB3FRocket1BattleText::
	db TX_START, "Stop meddling in"
	db "<LINE>", "TEAM ROCKET's"
	db "<CONT>", "affairs!"
	db "<DONE>"

;@ path: text/RocketHideoutB3F
_RocketHideoutB3FRocket1EndBattleText::
	db TX_START, "Oof!"
	db "<LINE>", "Taken down!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB3F
_RocketHideoutB3FRocket1AfterBattleText::
	db TX_START, "SILPH SCOPE?"
	db "<LINE>", "The machine the"
	db "<CONT>", "BOSS stole. It's"
	db "<CONT>", "here somewhere."
	db "<DONE>"

;@ path: text/RocketHideoutB3F
_RocketHideout3BattleText::
	db TX_START, "We got word from"
	db "<LINE>", "upstairs that you"
	db "<CONT>", "were coming!"
	db "<DONE>"

;@ path: text/RocketHideoutB3F
_RocketHideout3EndBattleText3::
	db TX_START, "What?"
	db "<LINE>", "I lost? No!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB3F
_RocketHide3AfterBattleText3::
	db TX_START, "Go ahead and go!"
	db "<LINE>", "But, you need the"
	db "<CONT>", "LIFT KEY to run"
	db "<CONT>", "the elevator!"
	db "<DONE>"
;@ path: text/RocketHideoutB4F
_RocketHideoutB4FGiovanniImpressedYouGotHereText::
	db TX_START, "So! I must say, I"
	db "<LINE>", "am impressed you"
	db "<CONT>", "got here!"
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FGiovanniWhatCannotBeText::
	db TX_START, "WHAT!"
	db "<LINE>", "This cannot be!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FGiovanniHopeWeMeetAgainText::
	db TX_START, "I see that you"
	db "<LINE>", "raise #MON"
	db "<CONT>", "with utmost care."

	db "<PARA>", "A child like you"
	db "<LINE>", "would never"
	db "<CONT>", "understand what I"
	db "<CONT>", "hope to achieve."

	db "<PARA>", "I shall step"
	db "<LINE>", "aside this time!"

	db "<PARA>", "I hope we meet"
	db "<LINE>", "again..."
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket1BattleText::
	db TX_START, "I know you! You"
	db "<LINE>", "ruined our plans"
	db "<CONT>", "at MT.MOON!"
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket1EndBattleText::
	db TX_START, "Burned"
	db "<LINE>", "again!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket1AfterBattleText::
	db TX_START, "Do you have"
	db "<LINE>", "something against"
	db "<CONT>", "TEAM ROCKET?"
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket2BattleText::
	db TX_START, "How can you not"
	db "<LINE>", "see the beauty of"
	db "<CONT>", "our evil?"
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket2EndBattleText::
	db TX_START, "Ayaya!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket2AfterBattleText::
	db TX_START, "BOSS! I'm sorry I"
	db "<LINE>", "failed you!"
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket3BattleText::
	db TX_START, "The elevator"
	db "<LINE>", "doesn't work? Who"
	db "<CONT>", "has the LIFT KEY?"
	db "<DONE>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket3EndBattleText::
	db TX_START, "No!"
	db "<PROMPT>"

;@ path: text/RocketHideoutB4F
_RocketHideoutB4FRocket3AfterBattleText::
	db TX_START, "Oh no! I dropped"
	db "<LINE>", "the LIFT KEY!"
	db "<DONE>"
;@ path: text/RocketHideoutElevator
_RocketHideoutElevatorAppearsToNeedKeyText::
	db TX_START, "It appears to"
	db "<LINE>", "need a key.@"
	db TX_END
;@ path: text/SilphCo2F
SilphCo2FSilphWorkerFPleaseTakeThisText::
	db TX_START, "Eeek!"
	db "<LINE>", "No! Stop! Help!"

	db "<PARA>", "Oh, you're not"
	db "<LINE>", "with TEAM ROCKET."
	db "<CONT>", "I thought..."
	db "<CONT>", "I'm sorry. Here,"
	db "<CONT>", "please take this!"
	db "<PROMPT>"

;@ path: text/SilphCo2F
_SilphCo2FSilphWorkerFReceivedTM36Text::
	db TX_START, "<PLAYER> got"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/SilphCo2F
_SilphCo2FSilphWorkerFTM36ExplanationText::
	db TX_START, "TM36 is"
	db "<LINE>", "SELFDESTRUCT!"

	db "<PARA>", "It's powerful, but"
	db "<LINE>", "the #MON that"
	db "<CONT>", "uses it faints!"
	db "<CONT>", "Be careful."
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FSilphWorkerFTM36NoRoomText::
	db TX_START, "You don't have any"
	db "<LINE>", "room for this."
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FScientist1BattleText::
	db TX_START, "Help! I'm a SILPH"
	db "<LINE>", "employee."
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FScientist1EndBattleText::
	db TX_START, "How"
	db "<LINE>", "did you know I"
	db "<CONT>", "was a ROCKET?"
	db "<PROMPT>"

;@ path: text/SilphCo2F
_SilphCo2FScientist1AfterBattleText::
	db TX_START, "I work for both"
	db "<LINE>", "SILPH and TEAM"
	db "<CONT>", "ROCKET!"
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FScientist2BattleText::
	db TX_START, "It's off limits"
	db "<LINE>", "here! Go home!"
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FScientist2EndBattleText::
	db TX_START, "You're"
	db "<LINE>", "good."
	db "<PROMPT>"

;@ path: text/SilphCo2F
_SilphCo2FScientist2AfterBattleText::
	db TX_START, "Can you solve the"
	db "<LINE>", "maze in here?"
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FRocket1BattleText::
	db TX_START, "No kids are"
	db "<LINE>", "allowed in here!"
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FRocket1EndBattleText::
	db TX_START, "Tough!"
	db "<PROMPT>"

;@ path: text/SilphCo2F
_SilphCo2FRocket1AfterBattleText::
	db TX_START, "Diamond shaped"
	db "<LINE>", "tiles are"
	db "<CONT>", "teleport blocks!"

	db "<PARA>", "They're hi-tech"
	db "<LINE>", "transporters!"
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FRocket2BattleText::
	db TX_START, "Hey kid! What are"
	db "<LINE>", "you doing here?"
	db "<DONE>"

;@ path: text/SilphCo2F
_SilphCo2FRocket2EndBattleText::
	db TX_START, "I goofed!"
	db "<PROMPT>"

;@ path: text/SilphCo2F
_SilphCo2FRocket2AfterBattleText::
	db TX_START, "SILPH CO. will"
	db "<LINE>", "be merged with"
	db "<CONT>", "TEAM ROCKET!"
	db "<DONE>"
;@ path: text/SilphCo3F
_SilphCo3FSilphWorkerMWhatShouldIDoText::
	db TX_START, "I work for SILPH."
	db "<LINE>", "What should I do?"
	db "<DONE>"

;@ path: text/SilphCo3F
_SilphCo3FSilphWorkerMYouSavedUsText::
	db TX_START, "<PLAYER>! You and"
	db "<LINE>", "your #MON"
	db "<CONT>", "saved us!"
	db "<DONE>"

;@ path: text/SilphCo3F
_SilphCo3FRocketBattleText::
	db TX_START, "Quit messing with"
	db "<LINE>", "us, kid!"
	db "<DONE>"

;@ path: text/SilphCo3F
_SilphCo3FRocketEndBattleText::
	db TX_START, "I give"
	db "<LINE>", "up!"
	db "<PROMPT>"

;@ path: text/SilphCo3F
_SilphCo3FRocketAfterBattleText::
	db TX_START, "A hint? You can"
	db "<LINE>", "open doors with a"
	db "<CONT>", "CARD KEY!"
	db "<DONE>"

;@ path: text/SilphCo3F
_SilphCo3FScientistBattleText::
	db TX_START, "I support TEAM"
	db "<LINE>", "ROCKET more than"
	db "<CONT>", "I support SILPH!"
	db "<DONE>"

;@ path: text/SilphCo3F
_SilphCo3FScientistEndBattleText::
	db TX_START, "You"
	db "<LINE>", "really got me!"
	db "<PROMPT>"

;@ path: text/SilphCo3F
_SilphCo3FScientistAfterBattleText::
	db TX_START, "Humph..."

	db "<PARA>", "TEAM ROCKET said"
	db "<LINE>", "that if I helped"
	db "<CONT>", "them, they'd let"
	db "<CONT>", "me study #MON!"
	db "<DONE>"
;@ path: text/SilphCo4F
_SilphCo4FSilphWorkerMImHidingText::
	db TX_START, "Sssh! Can't you"
	db "<LINE>", "see I'm hiding?"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FSilphWorkerMTeamRocketIsGoneText::
	db TX_START, "Huh? TEAM ROCKET"
	db "<LINE>", "is gone?"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FRocket1BattleText::
	db TX_START, "TEAM ROCKET has"
	db "<LINE>", "taken command of"
	db "<CONT>", "SILPH CO.!"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FRocket1EndBattleText::
	db TX_START, "Arrgh!"
	db "<PROMPT>"

;@ path: text/SilphCo4F
_SilphCo4FRocket1AfterBattleText::
	db TX_START, "Fwahahaha!"
	db "<LINE>", "My BOSS has been"
	db "<CONT>", "after this place!"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FScientistBattleText::
	db TX_START, "My #MON are my"
	db "<LINE>", "loyal soldiers!"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FScientistEndBattleText::
	db TX_START, "Darn!"
	db "<LINE>", "You weak #MON!"
	db "<PROMPT>"

;@ path: text/SilphCo4F
_SilphCo4FScientistAfterBattleText::
	db TX_START, "The doors are"
	db "<LINE>", "electronically"
	db "<CONT>", "locked! A CARD"
	db "<CONT>", "KEY opens them!"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FRocket2BattleText::
	db TX_START, "Intruder spotted!"
	db "<DONE>"

;@ path: text/SilphCo4F
_SilphCo4FRocket2EndBattleText::
	db TX_START, "Who"
	db "<LINE>", "are you?"
	db "<PROMPT>"

;@ path: text/SilphCo4F
_SilphCo4FRocket2AfterBattleText::
	db TX_START, "I better tell the"
	db "<LINE>", "BOSS on 11F!"
	db "<DONE>"
;@ path: text/SilphCo5F
_SilphCo5FSilphWorkerMThatsYouRightText::
	db TX_START, "TEAM ROCKET is"
	db "<LINE>", "in an uproar over"
	db "<CONT>", "some intruder."
	db "<CONT>", "That's you right?"
	db "<DONE>"

;@ path: text/SilphCo5F
_SilphCo5FSilphWorkerMYoureOurHeroText::
	db TX_START, "TEAM ROCKET took"
	db "<LINE>", "off! You're our"
	db "<CONT>", "hero! Thank you!"
	db "<DONE>"

;@ path: text/SilphCo5F
_SilphCo5FRocket1BattleText::
	db TX_START, "I heard a kid was"
	db "<LINE>", "wandering around."
	db "<DONE>"

;@ path: text/SilphCo5F
_SilphCo5FRocket1EndBattleText::
	db TX_START, "Boom!"
	db "<PROMPT>"

;@ path: text/SilphCo5F
_SilphCo5FRocket1AfterBattleText::
	db TX_START, "It's not smart"
	db "<LINE>", "to pick a fight"
	db "<CONT>", "with TEAM ROCKET!"
	db "<DONE>"

;@ path: text/SilphCo5F
_SilphCo5FScientistBattleText::
	db TX_START, "We study #"
	db "<LINE>", "BALL technology"
	db "<CONT>", "on this floor!"
	db "<DONE>"

;@ path: text/SilphCo5F
_SilphCo5FScientistEndBattleText::
	db TX_START, "Dang!"
	db "<LINE>", "Blast it!"
	db "<PROMPT>"

;@ path: text/SilphCo5F
_SilphCo5FScientistAfterBattleText::
	db TX_START, "We worked on the"
	db "<LINE>", "ultimate #"
	db "<CONT>", "BALL which would"
	db "<CONT>", "catch anything!"
	db "<DONE>"

;@ path: text/SilphCo5F
_SilphCo5FRockerBattleText::
	db TX_START, "Whaaat? There"
	db "<LINE>", "shouldn't be any"
	db "<CONT>", "children here?"
	db "<DONE>"


SECTION "Text 2", ROMX

;@ path: text/SilphCo5F_2
_SilphCo5FRockerEndBattleText::
	db TX_START, "Oh"
	db "<LINE>", "goodness!"
	db "<PROMPT>"

;@ path: text/SilphCo5F_2
_SilphCo5FRockerAfterBattleText::
	db TX_START, "You're only on 5F."
	db "<LINE>", "It's a long way"
	db "<CONT>", "to my BOSS!"
	db "<DONE>"

;@ path: text/SilphCo5F_2
_SilphCo5FRocket2BattleText::
	db TX_START, "Show TEAM ROCKET"
	db "<LINE>", "a little respect!"
	db "<DONE>"

;@ path: text/SilphCo5F_2
_SilphCo5FRocket2EndBattleText::
	db TX_START, "Cough..."
	db "<LINE>", "Cough..."
	db "<PROMPT>"

;@ path: text/SilphCo5F_2
_SilphCo5FRocket2AfterBattleText::
	db TX_START, "Which reminds me."

	db "<PARA>", "KOFFING evolves"
	db "<LINE>", "into WEEZING!"
	db "<DONE>"

;@ path: text/SilphCo5F_2
_SilphCo5FPokemonReport1Text::
	db TX_START, "It's a #MON"
	db "<LINE>", "REPORT!"

	db "<PARA>", "#MON LAB"
	db "<LINE>", "created PORYGON,"
	db "<CONT>", "the first virtual"
	db "<CONT>", "reality #MON."
	db "<DONE>"

;@ path: text/SilphCo5F_2
_SilphCo5FPokemonReport2Text::
	db TX_START, "It's a #MON"
	db "<LINE>", "REPORT!"

	db "<PARA>", "Over 160 #MON"
	db "<LINE>", "techniques have"
	db "<CONT>", "been confirmed."
	db "<DONE>"

;@ path: text/SilphCo5F_2
_SilphCo5FPokemonReport3Text::
	db TX_START, "It's a #MON"
	db "<LINE>", "REPORT!"

	db "<PARA>", "4 #MON evolve"
	db "<LINE>", "only when traded"
	db "<CONT>", "by link-cable."
	db "<DONE>"
;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerM1TookOverTheBuildingText::
	db TX_START, "The ROCKETs came"
	db "<LINE>", "and took over the"
	db "<CONT>", "building!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerM1BackToWorkText::
	db TX_START, "Well, better get"
	db "<LINE>", "back to work!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerMHelpMePleaseText::
	db TX_START, "Oh dear, oh dear."
	db "<LINE>", "Help me please!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerMWeGotEngagedText::
	db TX_START, "We got engaged!"
	db "<LINE>", "Heheh!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerF1SuchACowardText::
	db TX_START, "Look at him! He's"
	db "<LINE>", "such a coward!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerF1HaveToMarryHimText::
	db TX_START, "I feel so sorry"
	db "<LINE>", "for him, I have"
	db "<CONT>", "to marry him!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerF2TeamRocketConquerWorldText::
	db TX_START, "TEAM ROCKET is"
	db "<LINE>", "trying to conquer"
	db "<CONT>", "the world with"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerF2TeamRocketRanText::
	db TX_START, "TEAM ROCKET ran"
	db "<LINE>", "because of you!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerM3TargetedSilphText::
	db TX_START, "They must have"
	db "<LINE>", "targeted SILPH"
	db "<CONT>", "for our #MON"
	db "<CONT>", "products."
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FSilphWorkerM3WorkForSilphText::
	db TX_START, "Come work for"
	db "<LINE>", "SILPH when you"
	db "<CONT>", "get older!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FRocket1BattleText::
	db TX_START, "I am one of the 4"
	db "<LINE>", "ROCKET BROTHERS!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FRocket1EndBattleText::
	db TX_START, "Flame"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: text/SilphCo6F
_SilphCo6FRocket1AfterBattleText::
	db TX_START, "No matter!"
	db "<LINE>", "My brothers will"
	db "<CONT>", "avenge me!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FScientistBattleText::
	db TX_START, "That rotten"
	db "<LINE>", "PRESIDENT!"

	db "<PARA>", "He shouldn't have"
	db "<LINE>", "sent me to the"
	db "<CONT>", "TIKSI BRANCH!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FScientistEndBattleText::
	db TX_START, "Shoot!"
	db "<PROMPT>"

;@ path: text/SilphCo6F
_SilphCo6FScientistAfterBattleText::
	db TX_START, "TIKSI BRANCH?"
	db "<LINE>", "It's in Russian"
	db "<CONT>", "no man's land!"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FRocket2BattleText::
	db TX_START, "You dare betray"
	db "<LINE>", "TEAM ROCKET?"
	db "<DONE>"

;@ path: text/SilphCo6F
_SilphCo6FRocket2EndBattleText::
	db TX_START, "You"
	db "<LINE>", "traitor!"
	db "<PROMPT>"

;@ path: text/SilphCo6F
_SilphCo6FRocket2AfterBattleText::
	db TX_START, "If you stand for"
	db "<LINE>", "justice, you"
	db "<CONT>", "betray evil!"
	db "<DONE>"
;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM1HaveThisPokemonText::
	db TX_START, "Oh! Hi! You're"
	db "<LINE>", "not a ROCKET! You"
	db "<CONT>", "came to save us?"
	db "<CONT>", "Why, thank you!"

	db "<PARA>", "I want you to"
	db "<LINE>", "have this #MON"
	db "<CONT>", "for saving us."
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM1LaprasDescriptionText::
	db TX_START, "It's LAPRAS. It's"
	db "<LINE>", "very intelligent."

	db "<PARA>", "We kept it in our"
	db "<LINE>", "lab, but it will"
	db "<CONT>", "be much better"
	db "<CONT>", "off with you!"

	db "<PARA>", "I think you will"
	db "<LINE>", "be a good trainer"
	db "<CONT>", "for LAPRAS!"

	db "<PARA>", "It's a good"
	db "<LINE>", "swimmer. It'll"
	db "<CONT>", "give you a lift!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM1IsOurPresidentOkText::
	db TX_START, "TEAM ROCKET's"
	db "<LINE>", "BOSS went to the"
	db "<CONT>", "boardroom! Is our"
	db "<CONT>", "PRESIDENT OK?"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM1SavedText::
	db TX_START, "Saved at last!"
	db "<LINE>", "Thank you!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM2AfterTheMasterBallText::
	db TX_START, "TEAM ROCKET was"
	db "<LINE>", "after the MASTER"
	db "<CONT>", "BALL which will"
	db "<CONT>", "catch any #MON!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM2CancelledMasterBallText::
	db TX_START, "We canceled the"
	db "<LINE>", "MASTER BALL"
	db "<CONT>", "project because"
	db "<CONT>", "of TEAM ROCKET."
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM3ItWouldBeBadText::
	db TX_START, "It would be bad"
	db "<LINE>", "if TEAM ROCKET"
	db "<CONT>", "took over SILPH"
	db "<CONT>", "or our #MON!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM3YouChasedOffTeamRocketText::
	db TX_START, "Wow! You chased"
	db "<LINE>", "off TEAM ROCKET"
	db "<CONT>", "all by yourself?"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM4ItsReallyDangerousHereText::
	db TX_START, "You! It's really"
	db "<LINE>", "dangerous here!"
	db "<CONT>", "You came to save"
	db "<CONT>", "me? You can't!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FSilphWorkerM4SafeAtLastText::
	db TX_START, "Safe at last!"
	db "<LINE>", "Oh thank you!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRocket1BattleText::
	db TX_START, "Oh ho! I smell a"
	db "<LINE>", "little rat!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRocket1EndBattleText::
	db TX_START, "Lights"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FRocket1AfterBattleText::
	db TX_START, "You won't find my"
	db "<LINE>", "BOSS by just"
	db "<CONT>", "scurrying around!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FScientistBattleText::
	db TX_START, "Heheh!"

	db "<PARA>", "You mistook me for"
	db "<LINE>", "a SILPH worker?"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FScientistEndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "done!"
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FScientistAfterBattleText::
	db TX_START, "Despite your age,"
	db "<LINE>", "you are a skilled"
	db "<CONT>", "trainer!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRocket2BattleText::
	db TX_START, "I am one of the 4"
	db "<LINE>", "ROCKET BROTHERS!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRocket2EndBattleText::
	db TX_START, "Aack!"
	db "<LINE>", "Brothers, I lost!"
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FRocket2AfterBattleText::
	db TX_START, "Doesn't matter."
	db "<LINE>", "My brothers will"
	db "<CONT>", "repay the favor!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRocket3BattleText::
	db TX_START, "A child intruder?"
	db "<LINE>", "That must be you!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRocket3EndBattleText::
	db TX_START, "Fine!"
	db "<LINE>", "I lost!"
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FRocket3AfterBattleText::
	db TX_START, "Go on home"
	db "<LINE>", "before my BOSS"
	db "<CONT>", "gets ticked off!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRivalText::
	db TX_START, "<RIVAL>: What"
	db "<LINE>", "kept you <PLAYER>?"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRivalWaitedHereText::
	db TX_START, "<RIVAL>: Hahaha!"
	db "<LINE>", "I thought you'd"
	db "<CONT>", "turn up if I"
	db "<CONT>", "waited here!"

	db "<PARA>", "I guess TEAM"
	db "<LINE>", "ROCKET slowed you"
	db "<CONT>", "down! Not that I"
	db "<CONT>", "care!"

	db "<PARA>", "I saw you in"
	db "<LINE>", "SAFFRON, so I"
	db "<CONT>", "decided to see if"
	db "<CONT>", "you got better!"
	db "<DONE>"

;@ path: text/SilphCo7F
_SilphCo7FRivalDefeatedText::
	db TX_START, "Oh ho!"
	db "<LINE>", "So, you are ready"
	db "<CONT>", "for BOSS ROCKET!"
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FRivalVictoryText::
	db TX_START, "<RIVAL>: How can"
	db "<LINE>", "I put this?"

	db "<PARA>", "You're not good"
	db "<LINE>", "enough to play"
	db "<CONT>", "with us big boys!"
	db "<PROMPT>"

;@ path: text/SilphCo7F
_SilphCo7FRivalGoodLuckToYouText::
	db TX_START, "Well, <PLAYER>!"

	db "<PARA>", "I'm moving on up"
	db "<LINE>", "and ahead!"

	db "<PARA>", "By checking my"
	db "<LINE>", "#DEX, I'm"
	db "<CONT>", "starting to see"
	db "<CONT>", "what's strong and"
	db "<CONT>", "how they evolve!"

	db "<PARA>", "I'm going to the"
	db "<LINE>", "#MON LEAGUE"
	db "<CONT>", "to boot out the"
	db "<CONT>", "ELITE FOUR!"

	db "<PARA>", "I'll become the"
	db "<LINE>", "world's most"
	db "<CONT>", "powerful trainer!"

	db "<PARA>", "<PLAYER>, well"
	db "<LINE>", "good luck to you!"
	db "<CONT>", "Don't sweat it!"
	db "<CONT>", "Smell ya!"
	db "<DONE>"
;@ path: text/SilphCo8F
_SilphCo8FSilphWorkerMSilphIsFinishedText::
	db TX_START, "I wonder if SILPH"
	db "<LINE>", "is finished..."
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FSilphWorkerMThanksForSavingUsText::
	db TX_START, "Thanks for saving"
	db "<LINE>", "us!"
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FRocket1BattleText::
	db TX_START, "That's as far as"
	db "<LINE>", "you'll go!"
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FRocket1EndBattleText::
	db TX_START, "Not"
	db "<LINE>", "enough grit!"
	db "<PROMPT>"

;@ path: text/SilphCo8F
_SilphCo8FRocket1AfterBattleText::
	db TX_START, "If you don't turn"
	db "<LINE>", "back, I'll call"
	db "<CONT>", "for backup!"
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FScientistBattleText::
	db TX_START, "You're causing us"
	db "<LINE>", "problems!"
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FScientistEndBattleText::
	db TX_START, "Huh?"
	db "<LINE>", "I lost?"
	db "<PROMPT>"

;@ path: text/SilphCo8F
_SilphCo8FScientistAfterBattleText::
	db TX_START, "So, what do you"
	db "<LINE>", "think of SILPH"
	db "<CONT>", "BUILDING's maze?"
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FRocket2BattleText::
	db TX_START, "I am one of the 4"
	db "<LINE>", "ROCKET BROTHERS!"
	db "<DONE>"

;@ path: text/SilphCo8F
_SilphCo8FRocket2EndBattleText::
	db TX_START, "Whoo!"
	db "<LINE>", "Oh brothers!"
	db "<PROMPT>"

;@ path: text/SilphCo8F
_SilphCo8FRocket2AfterBattleText::
	db TX_START, "I'll leave you up"
	db "<LINE>", "to my brothers!"
	db "<DONE>"
;@ path: text/SilphCo9F
SilphCo9FNurseYouLookTiredText::
	db TX_START, "You look tired!"
	db "<LINE>", "You should take a"
	db "<CONT>", "quick nap!"
	db "<PROMPT>"

;@ path: text/SilphCo9F
SilphCo9FNurseDontGiveUpText::
	db TX_START, "Don't give up!"
	db "<DONE>"

;@ path: text/SilphCo9F
SilphCo9FNurseThankYouText::
	db TX_START, "Thank you so"
	db "<LINE>", "much!"
	db "<DONE>"

;@ path: text/SilphCo9F
_SilphCo9FRocket1BattleText::
	db TX_START, "Your #MON seem"
	db "<LINE>", "to adore you, kid!"
	db "<DONE>"

;@ path: text/SilphCo9F
_SilphCo9FRocket1EndBattleText::
	db TX_START, "Ghaaah!"
	db "<PROMPT>"

;@ path: text/SilphCo9F
_SilphCo9FRocket1AfterBattleText::
	db TX_START, "If I had started"
	db "<LINE>", "as a trainer at"
	db "<CONT>", "your age..."
	db "<DONE>"

;@ path: text/SilphCo9F
_SilphCo9FScientistBattleText::
	db TX_START, "Your #MON have"
	db "<LINE>", "weak points! I"
	db "<CONT>", "can nail them!"
	db "<DONE>"

;@ path: text/SilphCo9F
_SilphCo9FScientistEndBattleText::
	db TX_START, "You"
	db "<LINE>", "hammered me!"
	db "<PROMPT>"

;@ path: text/SilphCo9F
_SilphCo9FScientistAfterBattleText::
	db TX_START, "Exploiting weak"
	db "<LINE>", "spots does work!"
	db "<CONT>", "Think about"
	db "<CONT>", "element types!"
	db "<DONE>"

;@ path: text/SilphCo9F
_SilphCo9FRocket2BattleText::
	db TX_START, "I am one of the 4"
	db "<LINE>", "ROCKET BROTHERS!"
	db "<DONE>"

;@ path: text/SilphCo9F
_SilphCo9FRocket2EndBattleText::
	db TX_START, "Warg!"
	db "<LINE>", "Brothers, I lost!"
	db "<PROMPT>"

;@ path: text/SilphCo9F
_SilphCo9FRocket2AfterBattleText::
	db TX_START, "My brothers will"
	db "<LINE>", "avenge me!"
	db "<DONE>"
;@ path: text/SilphCo10F
_SilphCo10FSilphWorkerFImScaredText::
	db TX_START, "Waaaaa!"
	db "<CONT>", "I'm scared!"
	db "<DONE>"

;@ path: text/SilphCo10F
_SilphCo10FSilphWorkerFQuietAboutMyCryingText::
	db TX_START, "Please keep quiet"
	db "<LINE>", "about my crying!"
	db "<DONE>"

;@ path: text/SilphCo10F
_SilphCo10FRocketBattleText::
	db TX_START, "Welcome to the"
	db "<LINE>", "10F! So good of"
	db "<CONT>", "you to join me!"
	db "<DONE>"

;@ path: text/SilphCo10F
_SilphCo10FRocketEndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "stunned!"
	db "<PROMPT>"

;@ path: text/SilphCo10F
_SilphCo10FRocketAfterBattleText::
	db TX_START, "Nice try, but the"
	db "<LINE>", "boardroom is up"
	db "<CONT>", "one more floor!"
	db "<DONE>"

;@ path: text/SilphCo10F
_SilphCo10FScientistBattleText::
	db TX_START, "Enough of your"
	db "<LINE>", "silly games!"
	db "<DONE>"

;@ path: text/SilphCo10F
_SilphCo10FScientistEndBattleText::
	db TX_START, "No"
	db "<LINE>", "continues left!"
	db "<PROMPT>"

;@ path: text/SilphCo10F
_SilphCo10FScientistAfterBattleText::
	db TX_START, "Are you satisfied"
	db "<LINE>", "with beating me?"
	db "<CONT>", "Then go on home!"
	db "<DONE>"
;@ path: text/SilphCo11F
_SilphCo11FSilphPresidentText::
	db TX_START, "PRESIDENT: Thank"
	db "<LINE>", "you for saving"
	db "<CONT>", "SILPH!"

	db "<PARA>", "I will never"
	db "<LINE>", "forget you saved"
	db "<CONT>", "us in our moment"
	db "<CONT>", "of peril!"

	db "<PARA>", "I have to thank"
	db "<LINE>", "you in some way!"

	db "<PARA>", "Because I am rich,"
	db "<LINE>", "I can give you"
	db "<CONT>", "anything!"

	db "<PARA>", "Here, maybe this"
	db "<LINE>", "will do!"
	db "<PROMPT>"

;@ path: text/SilphCo11F
_SilphCo11FSilphPresidentReceivedMasterBallText::
	db TX_START, "<PLAYER> got a"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/SilphCo11F
_SilphCo11FSilphPresidentMasterBallDescriptionText::
	db TX_START, "PRESIDENT: You"
	db "<LINE>", "can't buy that"
	db "<CONT>", "anywhere!"

	db "<PARA>", "It's our secret"
	db "<LINE>", "prototype MASTER"
	db "<CONT>", "BALL!"

	db "<PARA>", "It will catch any"
	db "<LINE>", "#MON without"
	db "<CONT>", "fail!"

	db "<PARA>", "You should be"
	db "<LINE>", "quiet about using"
	db "<CONT>", "it, though."
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FSilphPresidentNoRoomText::
	db TX_START, "You have no"
	db "<LINE>", "room for this."
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FBeautyText::
	db TX_START, "SECRETARY: Thank"
	db "<LINE>", "you for rescuing"
	db "<CONT>", "all of us!"

	db "<PARA>", "We admire your"
	db "<LINE>", "courage."
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FGiovanniText::
	db TX_START, "Ah <PLAYER>!"
	db "<LINE>", "So we meet again!"

	db "<PARA>", "The PRESIDENT and"
	db "<LINE>", "I are discussing"
	db "<CONT>", "a vital business"
	db "<CONT>", "proposition."

	db "<PARA>", "Keep your nose"
	db "<LINE>", "out of grown-up"
	db "<CONT>", "matters..."

	db "<PARA>", "Or, experience a"
	db "<LINE>", "world of pain!"
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FGiovanniILostAgainText::
	db TX_START, "Arrgh!!"
	db "<LINE>", "I lost again!?"
	db "<PROMPT>"

;@ path: text/SilphCo11F
_SilphCo11FGiovanniYouRuinedOurPlansText::
	db TX_START, "Blast it all!"
	db "<LINE>", "You ruined our"
	db "<CONT>", "plans for SILPH!"

	db "<PARA>", "But, TEAM ROCKET"
	db "<LINE>", "will never fall!"

	db "<PARA>", "<PLAYER>! Never"
	db "<LINE>", "forget that all"
	db "<CONT>", "#MON exist"
	db "<CONT>", "for TEAM ROCKET!"

	db "<PARA>", "I must go, but I"
	db "<LINE>", "shall return!"
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FRocket1BattleText::
	db TX_START, "Stop right there!"
	db "<LINE>", "Don't you move!"
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FRocket1EndBattleText::
	db TX_START, "Don't..."
	db "<LINE>", "Please!"
	db "<PROMPT>"

;@ path: text/SilphCo11F
_SilphCo11FRocket1AfterBattleText::
	db TX_START, "So, you want to"
	db "<LINE>", "see my BOSS?"
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FRocket2BattleText::
	db TX_START, "Halt! Do you have"
	db "<LINE>", "an appointment"
	db "<CONT>", "with my BOSS?"
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FRocket2EndBattleText::
	db TX_START, "Gaah!"
	db "<LINE>", "Demolished!"
	db "<PROMPT>"

;@ path: text/SilphCo11F
_SilphCo11FRocket2AfterBattleText::
	db TX_START, "Watch your step,"
	db "<LINE>", "my BOSS likes his"
	db "<CONT>", "#MON tough!"
	db "<DONE>"

;@ path: text/SilphCo11F
_SilphCo11FPorygonText::
	db TX_START, "The monitor has"
	db "<LINE>", "#MON on it!"
	db "<DONE>"
;@ path: text/PokemonMansion2F
_PokemonMansion2FSuperNerdBattleText::
	db TX_START, "I can't get out!"
	db "<LINE>", "This old place is"
	db "<CONT>", "one big puzzle!"
	db "<DONE>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FSuperNerdEndBattleText::
	db TX_START, "Oh no!"
	db "<LINE>", "My bag of loot!"
	db "<PROMPT>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FSuperNerdAfterBattleText::
	db TX_START, "Switches open and"
	db "<LINE>", "close alternating"
	db "<CONT>", "sets of doors!"
	db "<DONE>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FDiary1Text::
	db TX_START, "Diary: July 5"
	db "<LINE>", "Guyana,"
	db "<CONT>", "South America"

	db "<PARA>", "A new #MON was"
	db "<LINE>", "discovered deep"
	db "<CONT>", "in the jungle."
	db "<DONE>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FDiary2Text::
	db TX_START, "Diary: July 10"
	db "<LINE>", "We christened the"
	db "<CONT>", "newly discovered"
	db "<CONT>", "#MON, MEW."
	db "<DONE>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FSwitchText::
	db TX_START, "A secret switch!"

	db "<PARA>", "Press it?"
	db "<DONE>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FSwitchPressedText::
	db TX_START, "Who wouldn't?"
	db "<PROMPT>"

;@ path: text/PokemonMansion2F
_PokemonMansion2FSwitchNotPressedText::
	db TX_START, "Not quite yet!"
	db "<DONE>"
;@ path: text/PokemonMansion3F
_PokemonMansion3FSuperNerdBattleText::
	db TX_START, "This place is"
	db "<LINE>", "like, huge!"
	db "<DONE>"

;@ path: text/PokemonMansion3F
_PokemonMansion3FSuperNerdEndBattleText::
	db TX_START, "Ayah!"
	db "<PROMPT>"

;@ path: text/PokemonMansion3F
_PokemonMansion3FSuperNerdAfterBattleText::
	db TX_START, "I wonder where"
	db "<LINE>", "my partner went."
	db "<DONE>"

;@ path: text/PokemonMansion3F
_PokemonMansion3FScientistBattleText::
	db TX_START, "My mentor once"
	db "<LINE>", "lived here."
	db "<DONE>"

;@ path: text/PokemonMansion3F
_PokemonMansion3FScientistEndBattleText::
	db TX_START, "Whew!"
	db "<LINE>", "Overwhelming!"
	db "<PROMPT>"

;@ path: text/PokemonMansion3F
_PokemonMansion3FScientistAfterBattleText::
	db TX_START, "So, you're stuck?"
	db "<LINE>", "Try jumping off"
	db "<CONT>", "over there!"
	db "<DONE>"

;@ path: text/PokemonMansion3F
_PokemonMansion3FDiaryText::
	db TX_START, "Diary: Feb. 6"
	db "<LINE>", "MEW gave birth."

	db "<PARA>", "We named the"
	db "<LINE>", "newborn MEWTWO."
	db "<DONE>"
;@ path: text/PokemonMansionB1F
_PokemonMansionB1FBurglarBattleText::
	db TX_START, "Uh-oh. Where am"
	db "<LINE>", "I now?"
	db "<DONE>"

;@ path: text/PokemonMansionB1F
_PokemonMansionB1FBurglarEndBattleText::
	db TX_START, "Awooh!"
	db "<PROMPT>"

;@ path: text/PokemonMansionB1F
_PokemonMansionB1FBurglarAfterBattleText::
	db TX_START, "You can find stuff"
	db "<LINE>", "lying around."
	db "<DONE>"

;@ path: text/PokemonMansionB1F
_PokemonMansionB1FScientistBattleText::
	db TX_START, "This place is"
	db "<LINE>", "ideal for a lab."
	db "<DONE>"

;@ path: text/PokemonMansionB1F
_PokemonMansionB1FScientistEndBattleText::
	db TX_START, "What"
	db "<LINE>", "was that for?"
	db "<PROMPT>"

;@ path: text/PokemonMansionB1F
_PokemonMansionB1FScientistAfterBattleText::
	db TX_START, "I like it here!"
	db "<LINE>", "It's conducive to"
	db "<CONT>", "my studies!"
	db "<DONE>"

;@ path: text/PokemonMansionB1F
_PokemonMansionB1FDiaryText::
	db TX_START, "Diary; Sept. 1"
	db "<LINE>", "MEWTWO is far too"
	db "<CONT>", "powerful."

	db "<PARA>", "We have failed to"
	db "<LINE>", "curb its vicious"
	db "<CONT>", "tendencies..."
	db "<DONE>"
;@ path: text/SafariZoneEast
_SafariZoneEastRestHouseSignText::
	db TX_START, "REST HOUSE"
	db "<DONE>"

;@ path: text/SafariZoneEast
_SafariZoneEastTrainerTipsText::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "The remaining time"
	db "<LINE>", "declines only"
	db "<CONT>", "while you walk!"
	db "<DONE>"

;@ path: text/SafariZoneEast
_SafariZoneEastSignText::
	db TX_START, "CENTER AREA"
	db "<LINE>", "NORTH: AREA 2"
	db "<DONE>"
;@ path: text/SafariZoneNorth
_SafariZoneNorthRestHouseSignText::
	db TX_START, "REST HOUSE"
	db "<DONE>"

;@ path: text/SafariZoneNorth
_SafariZoneNorthTrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "The SECRET HOUSE"
	db "<LINE>", "is still ahead!"
	db "<DONE>"

;@ path: text/SafariZoneNorth
_SafariZoneNorthSignText::
	db TX_START, "AREA 2"
	db "<DONE>"

;@ path: text/SafariZoneNorth
_SafariZoneNorthTrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "#MON hide in"
	db "<LINE>", "tall grass!"

	db "<PARA>", "Zigzag through"
	db "<LINE>", "grassy areas to"
	db "<CONT>", "flush them out."
	db "<DONE>"

;@ path: text/SafariZoneNorth
_SafariZoneNorthTrainerTips3Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Win a free HM for"
	db "<LINE>", "finding the"
	db "<CONT>", "SECRET HOUSE!"
	db "<DONE>"
;@ path: text/SafariZoneWest
_SafariZoneWestRestHouseSignText::
	db TX_START, "REST HOUSE"
	db "<DONE>"

;@ path: text/SafariZoneWest
_SafariZoneWestFindWardensTeethSignText::
	db TX_START, "REQUEST NOTICE"

	db "<PARA>", "Please find the"
	db "<LINE>", "SAFARI WARDEN's"
	db "<CONT>", "lost GOLD TEETH."
	db "<CONT>", "They're around"
	db "<CONT>", "here somewhere."

	db "<PARA>", "Reward offered!"
	db "<LINE>", "Contact: WARDEN"
	db "<DONE>"

;@ path: text/SafariZoneWest
_SafariZoneWestTrainerTipsText::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Zone Exploration"
	db "<LINE>", "Campaign!"

	db "<PARA>", "The Search for"
	db "<LINE>", "the SECRET HOUSE!"
	db "<DONE>"

;@ path: text/SafariZoneWest
_SafariZoneWestSignText::
	db TX_START, "AREA 3"
	db "<LINE>", "EAST: CENTER AREA"
	db "<DONE>"
;@ path: text/SafariZoneCenter
_SafariZoneCenterRestHouseSignText::
	db TX_START, "REST HOUSE"
	db "<DONE>"

;@ path: text/SafariZoneCenter
_SafariZoneCenterTrainerTipsSignText::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Press the START"
	db "<LINE>", "Button to check"
	db "<CONT>", "remaining time!"
	db "<DONE>"
;@ path: text/SafariZoneCenterRestHouse
_SafariZoneCenterRestHouseGirlText::
	db TX_START, "SARA: Where did"
	db "<LINE>", "my boy friend,"
	db "<CONT>", "ERIK, go?"
	db "<DONE>"

;@ path: text/SafariZoneCenterRestHouse
_SafariZoneCenterRestHouseScientistText::
	db TX_START, "I'm catching"
	db "<LINE>", "#MON to take"
	db "<CONT>", "home as gifts!"
	db "<DONE>"
;@ path: text/SafariZoneSecretHouse
_SafariZoneSecretHouseFishingGuruYouHaveWonText::
	db TX_START, "Ah! Finally!"

	db "<PARA>", "You're the first"
	db "<LINE>", "person to reach"
	db "<CONT>", "the SECRET HOUSE!"

	db "<PARA>", "I was getting"
	db "<LINE>", "worried that no"
	db "<CONT>", "one would win our"
	db "<CONT>", "campaign prize."

	db "<PARA>", "Congratulations!"
	db "<LINE>", "You have won!"
	db "<PROMPT>"

;@ path: text/SafariZoneSecretHouse
_SafariZoneSecretHouseFishingGuruReceivedHM03Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/SafariZoneSecretHouse
_SafariZoneSecretHouseFishingGuruHM03ExplanationText::
	db TX_START, "HM03 is SURF!"

	db "<PARA>", "#MON will be"
	db "<LINE>", "able to ferry you"
	db "<CONT>", "across water!"

	db "<PARA>", "And, this HM isn't"
	db "<LINE>", "disposable! You"
	db "<CONT>", "can use it over"
	db "<CONT>", "and over!"

	db "<PARA>", "You're super lucky"
	db "<LINE>", "for winning this"
	db "<CONT>", "fabulous prize!"
	db "<DONE>"

;@ path: text/SafariZoneSecretHouse
_SafariZoneSecretHouseFishingGuruHM03NoRoomText::
	db TX_START, "You don't have"
	db "<LINE>", "room for this"
	db "<CONT>", "fabulous prize!"
	db "<DONE>"
;@ path: text/SafariZoneWestRestHouse
_SafariZoneWestRestHouseScientistText::
	db TX_START, "Tossing ROCKs at"
	db "<LINE>", "#MON might"
	db "<CONT>", "make them run,"
	db "<CONT>", "but they'll be"
	db "<CONT>", "easier to catch."
	db "<DONE>"

;@ path: text/SafariZoneWestRestHouse
_SafariZoneWestRestHouseCooltrainerMText::
	db TX_START, "Using BAIT will"
	db "<LINE>", "make #MON"
	db "<CONT>", "easier to catch."
	db "<DONE>"

;@ path: text/SafariZoneWestRestHouse
_SafariZoneWestRestHouseSilphWorkerFText::
	db TX_START, "I hiked a lot, but"
	db "<LINE>", "I didn't see any"
	db "<CONT>", "#MON I wanted."
	db "<DONE>"
;@ path: text/SafariZoneEastRestHouse
_SafariZoneEastRestHouseScientistText::
	db TX_START, "How many did you"
	db "<LINE>", "catch? I'm bushed"
	db "<CONT>", "from the work!"
	db "<DONE>"

;@ path: text/SafariZoneEastRestHouse
_SafariZoneEastRestHouseRockerText::
	db TX_START, "I caught a"
	db "<LINE>", "CHANSEY!"

	db "<PARA>", "That makes this"
	db "<LINE>", "all worthwhile!"
	db "<DONE>"

;@ path: text/SafariZoneEastRestHouse
_SafariZoneEastRestHouseSilphWorkerMText::
	db TX_START, "Whew! I'm tired"
	db "<LINE>", "from all the fun!"
	db "<DONE>"
;@ path: text/SafariZoneNorthRestHouse
_SafariZoneNorthRestHouseScientistText::
	db TX_START, "You can keep any"
	db "<LINE>", "item you find on"
	db "<CONT>", "the ground here."

	db "<PARA>", "But, you'll run"
	db "<LINE>", "out of time if"
	db "<CONT>", "you try for all"
	db "<CONT>", "of them at once!"
	db "<DONE>"

;@ path: text/SafariZoneNorthRestHouse
_SafariZoneNorthRestHouseSafariZoneWorkerText::
	db TX_START, "Go to the deepest"
	db "<LINE>", "part of the"
	db "<CONT>", "SAFARI ZONE. You"
	db "<CONT>", "will win a prize!"
	db "<DONE>"

;@ path: text/SafariZoneNorthRestHouse
_SafariZoneNorthRestHouseGentlemanText::
	db TX_START, "My EEVEE evolved"
	db "<LINE>", "into FLAREON!"

	db "<PARA>", "But, a friend's"
	db "<LINE>", "EEVEE turned into"
	db "<CONT>", "a VAPOREON!"
	db "<CONT>", "I wonder why?"
	db "<DONE>"
;@ path: text/CeruleanCaveB1F
_MewtwoBattleText::
	db TX_START, "Mew!@"
	db TX_END
;@ path: text/VictoryRoad1F
_VictoryRoad1FCooltrainerFBattleText::
	db TX_START, "I wonder if you"
	db "<LINE>", "are good enough"
	db "<CONT>", "for me!"
	db "<DONE>"

;@ path: text/VictoryRoad1F
_VictoryRoad1FCooltrainerFEndBattleText::
	db TX_START, "I"
	db "<LINE>", "lost out!"
	db "<PROMPT>"

;@ path: text/VictoryRoad1F
_VictoryRoad1FCooltrainerFAfterBattleText::
	db TX_START, "I never wanted to"
	db "<LINE>", "lose to anybody!"
	db "<DONE>"

;@ path: text/VictoryRoad1F
_VictoryRoad1FCooltrainerMBattleText::
	db TX_START, "I can see you're"
	db "<LINE>", "good! Let me see"
	db "<CONT>", "exactly how good!"
	db "<DONE>"

;@ path: text/VictoryRoad1F
_VictoryRoad1FCooltrainerMEndBattleText::
	db TX_START, "I"
	db "<LINE>", "had a chance..."
	db "<PROMPT>"

;@ path: text/VictoryRoad1F
_VictoryRoad1FCooltrainerMAfterBattleText::
	db TX_START, "I concede, you're"
	db "<LINE>", "better than me!"
	db "<DONE>"
;@ path: text/LancesRoom
_LancesRoomLanceBeforeBattleText::
	db TX_START, "Ah! I heard about"
	db "<LINE>", "you <PLAYER>!"

	db "<PARA>", "I lead the ELITE"
	db "<LINE>", "FOUR! You can"
	db "<CONT>", "call me LANCE the"
	db "<CONT>", "dragon trainer!"

	db "<PARA>", "You know that"
	db "<LINE>", "dragons are"
	db "<CONT>", "mythical #MON!"

	db "<PARA>", "They're hard to"
	db "<LINE>", "catch and raise,"
	db "<CONT>", "but their powers"
	db "<CONT>", "are superior!"

	db "<PARA>", "They're virtually"
	db "<LINE>", "indestructible!"

	db "<PARA>", "Well, are you"
	db "<LINE>", "ready to lose?"

	db "<PARA>", "Your LEAGUE"
	db "<LINE>", "challenge ends"
	db "<CONT>", "with me, <PLAYER>!"
	db "<DONE>"

;@ path: text/LancesRoom
_LancesRoomLanceEndBattleText::
	db TX_START, "That's it!"

	db "<PARA>", "I hate to admit"
	db "<LINE>", "it, but you are a"
	db "<CONT>", "#MON master!"
	db "<PROMPT>"

;@ path: text/LancesRoom
_LancesRoomLanceAfterBattleText::
	db TX_START, "I still can't"
	db "<LINE>", "believe my"
	db "<CONT>", "dragons lost to"
	db "<CONT>", "you, <PLAYER>!"

	db "<PARA>", "You are now the"
	db "<LINE>", "#MON LEAGUE"
	db "<CONT>", "champion!"

	db "<PARA>", "...Or, you would"
	db "<LINE>", "have been, but"
	db "<CONT>", "you have one more"
	db "<CONT>", "challenge ahead."

	db "<PARA>", "You have to face"
	db "<LINE>", "another trainer!"
	db "<CONT>", "His name is..."

	db "<PARA>", "<RIVAL>!"
	db "<LINE>", "He beat the ELITE"
	db "<CONT>", "FOUR before you!"

	db "<PARA>", "He is the real"
	db "<LINE>", "#MON LEAGUE"
	db "<CONT>", "champion!@"
	db TX_END
;@ path: text/HallOfFame
_HallOfFameOakText::
	db TX_START, "OAK: Er-hem!"
	db "<LINE>", "Congratulations"
	db "<CONT>", "<PLAYER>!"

	db "<PARA>", "This floor is the"
	db "<LINE>", "#MON HALL OF"
	db "<CONT>", "FAME!"

	db "<PARA>", "#MON LEAGUE"
	db "<LINE>", "champions are"
	db "<CONT>", "honored for their"
	db "<CONT>", "exploits here!"

	db "<PARA>", "Their #MON are"
	db "<LINE>", "also recorded in"
	db "<CONT>", "the HALL OF FAME!"

	db "<PARA>", "<PLAYER>! You have"
	db "<LINE>", "endeavored hard"
	db "<CONT>", "to become the new"
	db "<CONT>", "LEAGUE champion!"

	db "<PARA>", "Congratulations,"
	db "<LINE>", "<PLAYER>, you and"
	db "<CONT>", "your #MON are"
	db "<CONT>", "HALL OF FAMERs!"
	db "<DONE>"
;@ path: text/ChampionsRoom
_ChampionsRoomRivalIntroText::
	db TX_START, "<RIVAL>: Hey!"

	db "<PARA>", "I was looking"
	db "<LINE>", "forward to seeing"
	db "<CONT>", "you, <PLAYER>!"

	db "<PARA>", "My rival should"
	db "<LINE>", "be strong to keep"
	db "<CONT>", "me sharp!"

	db "<PARA>", "While working on"
	db "<LINE>", "#DEX, I looked"
	db "<CONT>", "all over for"
	db "<CONT>", "powerful #MON!"

	db "<PARA>", "Not only that, I"
	db "<LINE>", "assembled teams"
	db "<CONT>", "that would beat"
	db "<CONT>", "any #MON type!"

	db "<PARA>", "And now!"

	db "<PARA>", "I'm the #MON"
	db "<LINE>", "LEAGUE champion!"

	db "<PARA>", "<PLAYER>! Do you"
	db "<LINE>", "know what that"
	db "<CONT>", "means?"

	db "<PARA>", "I'll tell you!"

	db "<PARA>", "I am the most"
	db "<LINE>", "powerful trainer"
	db "<CONT>", "in the world!"
	db "<DONE>"

;@ path: text/ChampionsRoom
_RivalDefeatedText::
	db TX_START, "NO!"
	db "<LINE>", "That can't be!"
	db "<CONT>", "You beat my best!"

	db "<PARA>", "After all that"
	db "<LINE>", "work to become"
	db "<CONT>", "LEAGUE champ?"

	db "<PARA>", "My reign is over"
	db "<LINE>", "already?"
	db "<CONT>", "It's not fair!"
	db "<PROMPT>"

;@ path: text/ChampionsRoom
_RivalVictoryText::
	db TX_START, "Hahaha!"
	db "<LINE>", "I won, I won!"

	db "<PARA>", "I'm too good for"
	db "<LINE>", "you, <PLAYER>!"

	db "<PARA>", "You did well to"
	db "<LINE>", "even reach me,"
	db "<CONT>", "<RIVAL>, the"
	db "<CONT>", "#MON genius!"

	db "<PARA>", "Nice try, loser!"
	db "<LINE>", "Hahaha!"
	db "<PROMPT>"

;@ path: text/ChampionsRoom
_ChampionsRoomRivalAfterBattleText::
	db TX_START, "Why?"
	db "<LINE>", "Why did I lose?"

	db "<PARA>", "I never made any"
	db "<LINE>", "mistakes raising"
	db "<CONT>", "my #MON..."

	db "<PARA>", "Darn it! You're"
	db "<LINE>", "the new #MON"
	db "<CONT>", "LEAGUE champion!"

	db "<PARA>", "Although I don't"
	db "<LINE>", "like to admit it."
	db "<DONE>"

;@ path: text/ChampionsRoom
_ChampionsRoomOakText::
	db TX_START, "OAK: <PLAYER>!"
	db "<DONE>"

;@ path: text/ChampionsRoom
_ChampionsRoomOakCongratulatesPlayerText::
	db TX_START, "OAK: So, you won!"
	db "<LINE>", "Congratulations!"
	db "<CONT>", "You're the new"
	db "<CONT>", "#MON LEAGUE"
	db "<CONT>", "champion!"

	db "<PARA>", "You've grown up so"
	db "<LINE>", "much since you"
	db "<CONT>", "first left with"
	db "<CONT>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"

	db "<PARA>", "<PLAYER>, you have"
	db "<LINE>", "come of age!"
	db "<DONE>"

;@ path: text/ChampionsRoom
_ChampionsRoomOakDisappointedWithRivalText::
	db TX_START, "OAK: <RIVAL>! I'm"
	db "<LINE>", "disappointed!"

	db "<PARA>", "I came when I"
	db "<LINE>", "heard you beat"
	db "<CONT>", "the ELITE FOUR!"

	db "<PARA>", "But, when I got"
	db "<LINE>", "here, you had"
	db "<CONT>", "already lost!"

	db "<PARA>", "<RIVAL>! Do you"
	db "<LINE>", "understand why"
	db "<CONT>", "you lost?"

	db "<PARA>", "You have forgotten"
	db "<LINE>", "to treat your"
	db "<CONT>", "#MON with"
	db "<CONT>", "trust and love!"

	db "<PARA>", "Without them, you"
	db "<LINE>", "will never become"
	db "<CONT>", "a champ again!"
	db "<DONE>"

;@ path: text/ChampionsRoom
_ChampionsRoomOakComeWithMeText::
	db TX_START, "OAK: <PLAYER>!"

	db "<PARA>", "You understand"
	db "<LINE>", "that your victory"
	db "<CONT>", "was not just your"
	db "<CONT>", "own doing!"

	db "<PARA>", "The bond you share"
	db "<LINE>", "with your #MON"
	db "<CONT>", "is marvelous!"

	db "<PARA>", "<PLAYER>!"
	db "<LINE>", "Come with me!"
	db "<DONE>"
;@ path: text/LoreleisRoom
_LoreleisRoomLoreleiBeforeBattleText::
	db TX_START, "Welcome to"
	db "<LINE>", "#MON LEAGUE!"

	db "<PARA>", "I am LORELEI of"
	db "<LINE>", "the ELITE FOUR!"

	db "<PARA>", "No one can best"
	db "<LINE>", "me when it comes"
	db "<CONT>", "to icy #MON!"

	db "<PARA>", "Freezing moves"
	db "<LINE>", "are powerful!"

	db "<PARA>", "Your #MON will"
	db "<LINE>", "be at my mercy"
	db "<CONT>", "when they are"
	db "<CONT>", "frozen solid!"

	db "<PARA>", "Hahaha!"
	db "<LINE>", "Are you ready?"
	db "<DONE>"

;@ path: text/LoreleisRoom
_LoreleisRoomLoreleiEndBattleText::
	db TX_START, "How"
	db "<LINE>", "dare you!"
	db "<PROMPT>"

;@ path: text/LoreleisRoom
_LoreleisRoomLoreleiAfterBattleText::
	db TX_START, "You're better"
	db "<LINE>", "than I thought!"
	db "<CONT>", "Go on ahead!"

	db "<PARA>", "You only got a"
	db "<LINE>", "taste of #MON"
	db "<CONT>", "LEAGUE power!"
	db "<DONE>"

;@ path: text/LoreleisRoom
_LoreleisRoomLoreleiDontRunAwayText::
	db TX_START, "Someone's voice:"
	db "<LINE>", "Don't run away!"
	db "<DONE>"
;@ path: text/BrunosRoom
_BrunoBeforeBattleText::
	db TX_START, "I am BRUNO of"
	db "<LINE>", "the ELITE FOUR!"

	db "<PARA>", "Through rigorous"
	db "<LINE>", "training, people"
	db "<CONT>", "and #MON can"
	db "<CONT>", "become stronger!"

	db "<PARA>", "I've weight"
	db "<LINE>", "trained with"
	db "<CONT>", "my #MON!"

	db "<PARA>", "<PLAYER>!"

	db "<PARA>", "We will grind you"
	db "<LINE>", "down with our"
	db "<CONT>", "superior power!"

	db "<PARA>", "Hoo hah!"
	db "<DONE>"

;@ path: text/BrunosRoom
_BrunoEndBattleText::
	db TX_START, "Why?"
	db "<LINE>", "How could I lose?"
	db "<PROMPT>"

;@ path: text/BrunosRoom
_BrunoAfterBattleText::
	db TX_START, "My job is done!"
	db "<LINE>", "Go face your next"
	db "<CONT>", "challenge!"
	db "<DONE>"

;@ path: text/BrunosRoom
_BrunosRoomBrunoDontRunAwayText::
	db TX_START, "Someone's voice:"
	db "<LINE>", "Don't run away!"
	db "<DONE>"
;@ path: text/AgathasRoom
_AgathaBeforeBattleText::
	db TX_START, "I am AGATHA of"
	db "<LINE>", "the ELITE FOUR!"

	db "<PARA>", "OAK's taken a lot"
	db "<LINE>", "of interest in"
	db "<CONT>", "you, child!"

	db "<PARA>", "That old duff was"
	db "<LINE>", "once tough and"
	db "<CONT>", "handsome! That"
	db "<CONT>", "was decades ago!"

	db "<PARA>", "Now he just wants"
	db "<LINE>", "to fiddle with"
	db "<CONT>", "his #DEX! He's"
	db "<CONT>", "wrong! #MON"
	db "<CONT>", "are for fighting!"

	db "<PARA>", "<PLAYER>! I'll show"
	db "<LINE>", "you how a real"
	db "<CONT>", "trainer fights!"
	db "<DONE>"

;@ path: text/AgathasRoom
_AgathaEndBattleText::
	db TX_START, "Oh ho!"
	db "<LINE>", "You're something"
	db "<CONT>", "special, child!"
	db "<PROMPT>"

;@ path: text/AgathasRoom
_AgathaAfterBattleText::
	db TX_START, "You win! I see"
	db "<LINE>", "what the old duff"
	db "<CONT>", "sees in you now!"

	db "<PARA>", "I have nothing"
	db "<LINE>", "else to say! Run"
	db "<CONT>", "along now, child!"
	db "<DONE>"

;@ path: text/AgathasRoom
_AgathasRoomAgathaDontRunAwayText::
	db TX_START, "Someone's voice:"
	db "<LINE>", "Don't run away!"
	db "<DONE>"
;@ path: text/RockTunnelB1F
_RockTunnelB1FCooltrainerF1BattleText::
	db TX_START, "Hikers leave twigs"
	db "<LINE>", "as trail markers."
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FCooltrainerF1EndBattleText::
	db TX_START, "Ohhh!"
	db "<LINE>", "I did my best!"
	db "<PROMPT>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FCooltrainerF1AfterBattleText::
	db TX_START, "I want to go "
	db "<LINE>", "home!"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker1BattleText::
	db TX_START, "Hahaha! Can you"
	db "<LINE>", "beat my power?"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker1EndBattleText::
	db TX_START, "Oops!"
	db "<LINE>", "Out-muscled!"
	db "<PROMPT>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker1AfterBattleText::
	db TX_START, "I go for power"
	db "<LINE>", "because I hate"
	db "<CONT>", "thinking!"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FSuperNerd1BattleText::
	db TX_START, "You have a"
	db "<LINE>", "#DEX?"
	db "<CONT>", "I want one too!"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FSuperNerd1EndBattleText::
	db TX_START, "Shoot!"
	db "<LINE>", "I'm so jealous!"
	db "<PROMPT>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FSuperNerd1AfterBattleText::
	db TX_START, "When you finish"
	db "<LINE>", "your #DEX, can"
	db "<CONT>", "I have it?"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FSuperNerd2BattleText::
	db TX_START, "Do you know about"
	db "<LINE>", "costume players?"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FSuperNerd2EndBattleText::
	db TX_START, "Well,"
	db "<LINE>", "that's that."
	db "<PROMPT>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FSuperNerd2AfterBattleText::
	db TX_START, "Costume players"
	db "<LINE>", "dress up as"
	db "<CONT>", "#MON for fun."
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker2BattleText::
	db TX_START, "My #MON"
	db "<LINE>", "techniques will"
	db "<CONT>", "leave you crying!"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker2EndBattleText::
	db TX_START, "I give!"
	db "<LINE>", "You're a better"
	db "<CONT>", "technician!"
	db "<PROMPT>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker2AfterBattleText::
	db TX_START, "In mountains,"
	db "<LINE>", "you'll often find"
	db "<CONT>", "rock-type #MON."
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FCooltrainerF2BattleText::
	db TX_START, "I don't often"
	db "<LINE>", "come here, but I"
	db "<CONT>", "will fight you."
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FCooltrainerF2EndBattleText::
	db TX_START, "Oh!"
	db "<LINE>", "I lost!"
	db "<PROMPT>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FCooltrainerF2AfterBattleText::
	db TX_START, "I like tiny"
	db "<LINE>", "#MON, big ones"
	db "<CONT>", "are too scary!"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker3BattleText::
	db TX_START, "Hit me with your"
	db "<LINE>", "best shot!"
	db "<DONE>"

;@ path: text/RockTunnelB1F
_RockTunnelB1FHiker3EndBattleText::
	db TX_START, "Fired"
	db "<LINE>", "away!"
	db "<PROMPT>"


SECTION "Text 3", ROMX

;@ path: text/RockTunnelB1F_2
_RockTunnelB1FHiker3AfterBattleText::
	db TX_START, "I'll raise my"
	db "<LINE>", "#MON to beat"
	db "<CONT>", "yours, kid!"
	db "<DONE>"

;@ path: text/RockTunnelB1F_2
_RockTunnelB1FSuperNerd3BattleText::
	db TX_START, "I draw #MON"
	db "<LINE>", "when I'm home."
	db "<DONE>"

;@ path: text/RockTunnelB1F_2
_RockTunnelB1FSuperNerd3EndBattleText::
	db TX_START, "Whew!"
	db "<LINE>", "I'm exhausted!"
	db "<PROMPT>"

;@ path: text/RockTunnelB1F_2
_RockTunnelB1FSuperNerd3AfterBattleText::
	db TX_START, "I'm an artist,"
	db "<LINE>", "not a fighter."
	db "<DONE>"
;@ path: text/SeafoamIslandsB4F
_SeafoamIslandsB4FArticunoBattleText::
	db TX_START, "Gyaoo!@"
	db TX_END

;@ path: text/SeafoamIslandsB4F
_SeafoamIslandsB4FBouldersSignText::
	db TX_START, "Boulders might"
	db "<LINE>", "change the flow"
	db "<CONT>", "of water!"
	db "<DONE>"

;@ path: text/SeafoamIslandsB4F
_SeafoamIslandsB4FDangerSignText::
	db TX_START, "DANGER"
	db "<LINE>", "Fast current!"
	db "<DONE>"

;@ path: data/text/text_2
_AIBattleWithdrawText::
	db TX_RAM
	dw wTrainerName
	db TX_START, " with-"
	db "<LINE>", "drew @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_2
_AIBattleUseItemText::
	db TX_RAM
	dw wTrainerName
	db TX_START
	db "<LINE>", "used @"
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<CONT>", "on @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_2
_TradeWentToText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, " went"
	db "<LINE>", "to @"
	db TX_RAM
	dw wLinkEnemyTrainerName
	db TX_START, "."
	db "<DONE>"

;@ path: data/text/text_2
_TradeForText::
	db TX_START, "For <PLAYER>'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, ","
	db "<DONE>"

;@ path: data/text/text_2
_TradeSendsText::
	db TX_RAM
	dw wLinkEnemyTrainerName
	db TX_START, " sends"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "."
	db "<DONE>"

;@ path: data/text/text_2
_TradeWavesFarewellText::
	db TX_RAM
	dw wLinkEnemyTrainerName
	db TX_START, " waves"
	db "<LINE>", "farewell as"
	db "<DONE>"

;@ path: data/text/text_2
_TradeTransferredText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " is"
	db "<LINE>", "transferred."
	db "<DONE>"

;@ path: data/text/text_2
_TradeTakeCareText::
	db TX_START, "Take good care of"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "."
	db "<DONE>"

;@ path: data/text/text_2
_TradeWillTradeText::
	db TX_RAM
	dw wLinkEnemyTrainerName
	db TX_START, " will"
	db "<LINE>", "trade @"
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<DONE>"

;@ path: data/text/text_2
_TradeforText::
	db TX_START, "for <PLAYER>'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "."
	db "<DONE>"

;@ path: data/text/text_2
_PlaySlotMachineText::
	db TX_START, "A slot machine!"
	db "<LINE>", "Want to play?"
	db "<DONE>"

;@ path: data/text/text_2
_OutOfCoinsSlotMachineText::
	db TX_START, "Darn!"
	db "<LINE>", "Ran out of coins!"
	db "<DONE>"

;@ path: data/text/text_2
_BetHowManySlotMachineText::
	db TX_START, "Bet how many"
	db "<LINE>", "coins?"
	db "<DONE>"

;@ path: data/text/text_2
_StartSlotMachineText::
	db TX_START, "Start!"
	db "<DONE>"

;@ path: data/text/text_2
_NotEnoughCoinsSlotMachineText::
	db TX_START, "Not enough"
	db "<LINE>", "coins!"
	db "<PROMPT>"

;@ path: data/text/text_2
_OneMoreGoSlotMachineText::
	db TX_START, "One more "
	db "<LINE>", "go?"
	db "<DONE>"

;@ path: data/text/text_2
_LinedUpText::
	db TX_START, " lined up!"
	db "<LINE>", "Scored @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, " coins!"
	db "<DONE>"

;@ path: data/text/text_2
_NotThisTimeText::
	db TX_START, "Not this time!"
	db "<PROMPT>"

;@ path: data/text/text_2
_YeahText::
	db TX_START, "Yeah!@"
	db TX_END

;@ path: data/text/text_2
_DexSeenOwnedText::
	db TX_START, "#DEX   Seen:@"
	db TX_NUM
	dw wDexRatingNumMonsSeen
	db ((1) << 4) | (3)
	db TX_START
	db "<LINE>", "         Owned:@"
	db TX_NUM
	dw wDexRatingNumMonsOwned
	db ((1) << 4) | (3)
	db TX_END

;@ path: data/text/text_2
_DexRatingText::
	db TX_START, "#DEX Rating<COLON>"
	db "<DONE>"

;@ path: data/text/text_2
_GymStatueText1::
	db TX_RAM
	dw wGymCityName
	db TX_START
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: @"
	db TX_RAM
	dw wGymLeaderName
	db TX_START

	db "<PARA>", "WINNING TRAINERS:"
	db "<LINE>", "<RIVAL>"
	db "<DONE>"

;@ path: data/text/text_2
_GymStatueText2::
	db TX_RAM
	dw wGymCityName
	db TX_START
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: @"
	db TX_RAM
	dw wGymLeaderName
	db TX_START

	db "<PARA>", "WINNING TRAINERS:"
	db "<LINE>", "<RIVAL>"
	db "<CONT>", "<PLAYER>"
	db "<DONE>"

;@ path: data/text/text_2
_ViridianCityPokecenterGuyText::
	db TX_START, "#MON CENTERs"
	db "<LINE>", "heal your tired,"
	db "<CONT>", "hurt or fainted"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: data/text/text_2
_PewterCityPokecenterGuyText::
	db TX_START, "Yawn!"

	db "<PARA>", "When JIGGLYPUFF"
	db "<LINE>", "sings, #MON"
	db "<CONT>", "get drowsy..."

	db "<PARA>", "...Me too..."
	db "<LINE>", "Snore..."
	db "<DONE>"

;@ path: data/text/text_2
_CeruleanPokecenterGuyText::
	db TX_START, "BILL has lots of"
	db "<LINE>", "#MON!"

	db "<PARA>", "He collects rare"
	db "<LINE>", "ones too!"
	db "<DONE>"

;@ path: data/text/text_2
_LavenderPokecenterGuyText::
	db TX_START, "CUBONEs wear"
	db "<LINE>", "skulls, right?"

	db "<PARA>", "People will pay a"
	db "<LINE>", "lot for one!"
	db "<DONE>"

;@ path: data/text/text_2
_MtMoonPokecenterBenchGuyText::
	db TX_START, "If you have too"
	db "<LINE>", "many #MON, you"
	db "<CONT>", "should store them"
	db "<CONT>", "via PC!"
	db "<DONE>"

;@ path: data/text/text_2
_RockTunnelPokecenterGuyText::
	db TX_START, "I heard that"
	db "<LINE>", "GHOSTs haunt"
	db "<CONT>", "LAVENDER TOWN!"
	db "<DONE>"

;@ path: data/text/text_2
_UnusedBenchGuyText1::
	db TX_START, "I wish I could"
	db "<LINE>", "catch #MON."
	db "<DONE>"

;@ path: data/text/text_2
_UnusedBenchGuyText2::
	db TX_START, "I'm tired from"
	db "<LINE>", "all the fun..."
	db "<DONE>"

;@ path: data/text/text_2
_UnusedBenchGuyText3::
	db TX_START, "SILPH's manager"
	db "<LINE>", "is hiding in the"
	db "<CONT>", "SAFARI ZONE."
	db "<DONE>"

;@ path: data/text/text_2
_VermilionPokecenterGuyText::
	db TX_START, "It is true that a"
	db "<LINE>", "higher level"
	db "<CONT>", "#MON will be"
	db "<CONT>", "more powerful..."

	db "<PARA>", "But, all #MON"
	db "<LINE>", "will have weak"
	db "<CONT>", "points against"
	db "<CONT>", "specific types."

	db "<PARA>", "So, there is no"
	db "<LINE>", "universally"
	db "<CONT>", "strong #MON."
	db "<DONE>"

;@ path: data/text/text_2
_CeladonCityPokecenterGuyText::
	db TX_START, "If I had a BIKE,"
	db "<LINE>", "I would go to"
	db "<CONT>", "CYCLING ROAD!"
	db "<DONE>"

;@ path: data/text/text_2
_FuchsiaCityPokecenterGuyText::
	db TX_START, "If you're studying "
	db "<LINE>", "#MON, visit"
	db "<CONT>", "the SAFARI ZONE."

	db "<PARA>", "It has all sorts"
	db "<LINE>", "of rare #MON."
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarPokecenterGuyText::
	db TX_START, "#MON can still"
	db "<LINE>", "learn techniques"
	db "<CONT>", "after canceling"
	db "<CONT>", "evolution."

	db "<PARA>", "Evolution can wait"
	db "<LINE>", "until new moves"
	db "<CONT>", "have been learned."
	db "<DONE>"

;@ path: data/text/text_2
_SaffronCityPokecenterGuyText1::
	db TX_START, "It would be great"
	db "<LINE>", "if the ELITE FOUR"
	db "<CONT>", "came and stomped"
	db "<CONT>", "TEAM ROCKET!"
	db "<DONE>"

;@ path: data/text/text_2
_SaffronCityPokecenterGuyText2::
	db TX_START, "TEAM ROCKET took"
	db "<LINE>", "off! We can go"
	db "<CONT>", "out safely again!"
	db "<CONT>", "That's great!"
	db "<DONE>"

;@ path: data/text/text_2
_CeladonCityHotelText::
	db TX_START, "My sis brought me"
	db "<LINE>", "on this vacation!"
	db "<DONE>"

;@ path: data/text/text_2
_BookcaseText::
	db TX_START, "Crammed full of"
	db "<LINE>", "#MON books!"
	db "<DONE>"

;@ path: data/text/text_2
_NewBicycleText::
	db TX_START, "A shiny new"
	db "<LINE>", "BICYCLE!"
	db "<DONE>"

;@ path: data/text/text_2
_PushStartText::
	db TX_START, "Push START to"
	db "<LINE>", "open the MENU!"
	db "<DONE>"

;@ path: data/text/text_2
_SaveOptionText::
	db TX_START, "The SAVE option is"
	db "<LINE>", "on the MENU"
	db "<CONT>", "screen."
	db "<DONE>"

;@ path: data/text/text_2
_StrengthsAndWeaknessesText::
	db TX_START, "All #MON types"
	db "<LINE>", "have strong and"
	db "<CONT>", "weak points"
	db "<CONT>", "against others."
	db "<DONE>"

;@ path: data/text/text_2
_TimesUpText::
	db TX_START, "PA: Ding-dong!"

	db "<PARA>", "Time's up!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GameOverText::
	db TX_START, "PA: Your SAFARI"
	db "<LINE>", "GAME is over!"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarGymQuizIntroText::
	db TX_START, "#MON Quiz!"

	db "<PARA>", "Get it right and"
	db "<LINE>", "the door opens to"
	db "<CONT>", "the next room!"

	db "<PARA>", "Get it wrong and"
	db "<LINE>", "face a trainer!"

	db "<PARA>", "If you want to"
	db "<LINE>", "conserve your"
	db "<CONT>", "#MON for the"
	db "<CONT>", "GYM LEADER..."

	db "<PARA>", "Then get it right!"
	db "<LINE>", "Here we go!"
	db "<PROMPT>"

;@ path: data/text/text_2
_CinnabarQuizQuestionsText1::
	db TX_START, "CATERPIE evolves"
	db "<LINE>", "into BUTTERFREE?"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarQuizQuestionsText2::
	db TX_START, "There are 9"
	db "<LINE>", "certified #MON"
	db "<CONT>", "LEAGUE BADGEs?"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarQuizQuestionsText3::
	db TX_START, "POLIWAG evolves 3"
	db "<LINE>", "times?"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarQuizQuestionsText4::
	db TX_START, "Are thunder moves"
	db "<LINE>", "effective against"
	db "<CONT>", "ground element-"
	db "<CONT>", "type #MON?"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarQuizQuestionsText5::
	db TX_START, "#MON of the"
	db "<LINE>", "same kind and"
	db "<CONT>", "level are not"
	db "<CONT>", "identical?"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarQuizQuestionsText6::
	db TX_START, "TM28 contains"
	db "<LINE>", "TOMBSTONER?"
	db "<DONE>"

;@ path: data/text/text_2
_CinnabarGymQuizCorrectText::
	db TX_START, "You're absolutely"
	db "<LINE>", "correct!"

	db "<PARA>", "Go on through!@"
	db TX_END

;@ path: data/text/text_2
_CinnabarGymQuizIncorrectText::
	db TX_START, "Sorry! Bad call!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MagazinesText::
	db TX_START, "#MON magazines!"

	db "<PARA>", "#MON notebooks!"

	db "<PARA>", "#MON graphs!"
	db "<DONE>"

;@ path: data/text/text_2
_BillsHouseMonitorText::
	db TX_START, "TELEPORTER is"
	db "<LINE>", "displayed on the"
	db "<CONT>", "PC monitor."
	db "<DONE>"

;@ path: data/text/text_2
_BillsHouseInitiatedText::
	db TX_START, "<PLAYER> initiated"
	db "<LINE>", "TELEPORTER's Cell"
	db "<CONT>", "Separator!@"
	db TX_END

;@ path: data/text/text_2
_BillsHousePokemonListText1::
	db TX_START, "BILL's favorite"
	db "<LINE>", "#MON list!"
	db "<PROMPT>"

;@ path: data/text/text_2
_BillsHousePokemonListText2::
	db TX_START, "Which #MON do"
	db "<LINE>", "you want to see?"
	db "<DONE>"

;@ path: data/text/text_2
_OakLabEmailText::
	db TX_START, "There's an e-mail"
	db "<LINE>", "message here!"

	db "<PARA>", "..."

	db "<PARA>", "Calling all"
	db "<LINE>", "#MON trainers!"

	db "<PARA>", "The elite trainers"
	db "<LINE>", "of #MON LEAGUE"
	db "<CONT>", "are ready to take"
	db "<CONT>", "on all comers!"

	db "<PARA>", "Bring your best"
	db "<LINE>", "#MON and see"
	db "<CONT>", "how you rate as a"
	db "<CONT>", "trainer!"

	db "<PARA>", "#MON LEAGUE HQ"
	db "<LINE>", "INDIGO PLATEAU"

	db "<PARA>", "PS: PROF.OAK,"
	db "<LINE>", "please visit us!"
	db "<CONT>", "..."
	db "<DONE>"

;@ path: data/text/text_2
_GameCornerCoinCaseText::
	db TX_START, "A COIN CASE is"
	db "<LINE>", "required!"
	db "<DONE>"

;@ path: data/text/text_2
_GameCornerNoCoinsText::
	db TX_START, "You don't have"
	db "<LINE>", "any coins!"
	db "<DONE>"

;@ path: data/text/text_2
_GameCornerOutOfOrderText::
	db TX_START, "OUT OF ORDER"
	db "<LINE>", "This is broken."
	db "<DONE>"

;@ path: data/text/text_2
_GameCornerOutToLunchText::
	db TX_START, "OUT TO LUNCH"
	db "<LINE>", "This is reserved."
	db "<DONE>"

;@ path: data/text/text_2
_GameCornerSomeonesKeysText::
	db TX_START, "Someone's keys!"
	db "<LINE>", "They'll be back."
	db "<DONE>"

;@ path: data/text/text_2
_JustAMomentText::
	db TX_START, "Just a moment."
	db "<DONE>"

;@ path: data/text/text_2
TMNotebookText::
	db TX_START, "It's a pamphlet"
	db "<LINE>", "on TMs."

	db "<PARA>", "..."

	db "<PARA>", "There are 50 TMs"
	db "<LINE>", "in all."

	db "<PARA>", "There are also 5"
	db "<LINE>", "HMs that can be"
	db "<CONT>", "used repeatedly."

	db "<PARA>", "SILPH CO.@"
	db TX_END

;@ path: data/text/text_2
_TurnPageText::
	db TX_START, "Turn the page?"
	db "<DONE>"

;@ path: data/text/text_2
_ViridianSchoolNotebookText5::
	db TX_START, "GIRL: Hey! Don't"
	db "<LINE>", "look at my notes!@"
	db TX_END

;@ path: data/text/text_2
_ViridianSchoolNotebookText1::
	db TX_START, "Looked at the"
	db "<LINE>", "notebook!"

	db "<PARA>", "First page..."

	db "<PARA>", "# BALLs are"
	db "<LINE>", "used to catch"
	db "<CONT>", "#MON."

	db "<PARA>", "Up to 6 #MON"
	db "<LINE>", "can be carried."

	db "<PARA>", "People who raise"
	db "<LINE>", "and make #MON"
	db "<CONT>", "fight are called"
	db "<CONT>", "#MON trainers."
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianSchoolNotebookText2::
	db TX_START, "Second page..."

	db "<PARA>", "A healthy #MON"
	db "<LINE>", "may be hard to"
	db "<CONT>", "catch, so weaken"
	db "<CONT>", "it first!"

	db "<PARA>", "Poison, burns and"
	db "<LINE>", "other damage are"
	db "<CONT>", "effective!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianSchoolNotebookText3::
	db TX_START, "Third page..."

	db "<PARA>", "#MON trainers"
	db "<LINE>", "seek others to"
	db "<CONT>", "engage in #MON"
	db "<CONT>", "fights."

	db "<PARA>", "Battles are"
	db "<LINE>", "constantly fought"
	db "<CONT>", "at #MON GYMs."
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianSchoolNotebookText4::
	db TX_START, "Fourth page..."

	db "<PARA>", "The goal for"
	db "<LINE>", "#MON trainers"
	db "<CONT>", "is to beat the "
	db "<CONT>", "top 8 #MON"
	db "<CONT>", "GYM LEADERs."

	db "<PARA>", "Do so to earn the"
	db "<LINE>", "right to face..."

	db "<PARA>", "The ELITE FOUR of"
	db "<LINE>", "#MON LEAGUE!"
	db "<PROMPT>"

;@ path: data/text/text_2
_EnemiesOnEverySideText::
	db TX_START, "Enemies on every"
	db "<LINE>", "side!"
	db "<DONE>"

;@ path: data/text/text_2
_WhatGoesAroundComesAroundText::
	db TX_START, "What goes around"
	db "<LINE>", "comes around!"
	db "<DONE>"

;@ path: data/text/text_2
_FightingDojoText::
	db TX_START, "FIGHTING DOJO"
	db "<DONE>"

;@ path: data/text/text_2
_IndigoPlateauHQText::
	db TX_START, "INDIGO PLATEAU"
	db "<LINE>", "#MON LEAGUE HQ"
	db "<DONE>"

;@ path: data/text/text_2
_RedBedroomSNESText::
	db TX_START, "<PLAYER> is"
	db "<LINE>", "playing the SNES!"
	db "<CONT>", "...Okay!"
	db "<CONT>", "It's time to go!"
	db "<DONE>"

;@ path: data/text/text_2
_Route15UpstairsBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars..."

	db "<PARA>", "A large, shining"
	db "<LINE>", "bird is flying"
	db "<CONT>", "toward the sea."
	db "<DONE>"

;@ path: data/text/text_2
_AerodactylFossilText::
	db TX_START, "AERODACTYL Fossil"
	db "<LINE>", "A primitive and"
	db "<CONT>", "rare #MON."
	db "<DONE>"

;@ path: data/text/text_2
_KabutopsFossilText::
	db TX_START, "KABUTOPS Fossil"
	db "<LINE>", "A primitive and"
	db "<CONT>", "rare #MON."
	db "<DONE>"

;@ path: data/text/text_2
_LinkCableHelpText1::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Using a Game Link"
	db "<LINE>", "Cable"
	db "<PROMPT>"

;@ path: data/text/text_2
_LinkCableHelpText2::
	db TX_START, "Which heading do"
	db "<LINE>", "you want to read?"
	db "<DONE>"

;@ path: data/text/text_2
_LinkCableInfoText1::
	db TX_START, "When you have"
	db "<LINE>", "linked your GAME"
	db "<CONT>", "BOY with another"
	db "<CONT>", "GAME BOY, talk to"
	db "<CONT>", "the attendant on"
	db "<CONT>", "the right in any"
	db "<CONT>", "#MON CENTER."
	db "<PROMPT>"

;@ path: data/text/text_2
_LinkCableInfoText2::
	db TX_START, "COLOSSEUM lets"
	db "<LINE>", "you play against"
	db "<CONT>", "a friend."
	db "<PROMPT>"

;@ path: data/text/text_2
_LinkCableInfoText3::
	db TX_START, "TRADE CENTER is"
	db "<LINE>", "used for trading"
	db "<CONT>", "#MON."
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianSchoolBlackboardText1::
	db TX_START, "The blackboard"
	db "<LINE>", "describes #MON"
	db "<CONT>", "STATUS changes"
	db "<CONT>", "during battles."
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianSchoolBlackboardText2::
	db TX_START, "Which heading do"
	db "<LINE>", "you want to read?"
	db "<DONE>"

;@ path: data/text/text_2
_ViridianBlackboardSleepText::
	db TX_START, "A #MON can't"
	db "<LINE>", "attack if it's"
	db "<CONT>", "asleep!"

	db "<PARA>", "#MON will stay"
	db "<LINE>", "asleep even after"
	db "<CONT>", "battles."

	db "<PARA>", "Use AWAKENING to"
	db "<LINE>", "wake them up!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianBlackboardPoisonText::
	db TX_START, "When poisoned, a"
	db "<LINE>", "#MON's health"
	db "<CONT>", "steadily drops."

	db "<PARA>", "Poison lingers"
	db "<LINE>", "after battles."

	db "<PARA>", "Use an ANTIDOTE"
	db "<LINE>", "to cure poison!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianBlackboardPrlzText::
	db TX_START, "Paralysis could"
	db "<LINE>", "make #MON"
	db "<CONT>", "moves misfire!"

	db "<PARA>", "Paralysis remains"
	db "<LINE>", "after battles."

	db "<PARA>", "Use PARLYZ HEAL"
	db "<LINE>", "for treatment!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianBlackboardBurnText::
	db TX_START, "A burn reduces"
	db "<LINE>", "power and speed."
	db "<CONT>", "It also causes"
	db "<CONT>", "ongoing damage."

	db "<PARA>", "Burns remain"
	db "<LINE>", "after battles."

	db "<PARA>", "Use BURN HEAL to"
	db "<LINE>", "cure a burn!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ViridianBlackboardFrozenText::
	db TX_START, "If frozen, a"
	db "<LINE>", "#MON becomes"
	db "<CONT>", "totally immobile!"

	db "<PARA>", "It stays frozen"
	db "<LINE>", "even after the"
	db "<CONT>", "battle ends."

	db "<PARA>", "Use ICE HEAL to"
	db "<LINE>", "thaw out #MON!"
	db "<PROMPT>"

;@ path: data/text/text_2
_VermilionGymTrashText::
	db TX_START, "Nope, there's"
	db "<LINE>", "only trash here."
	db "<DONE>"

;@ path: data/text/text_2
_VermilionGymTrashSuccessText1::
	db TX_START, "Hey! There's a"
	db "<LINE>", "switch under the"
	db "<CONT>", "trash!"
	db "<CONT>", "Turn it on!"

	db "<PARA>", "The 1st electric"
	db "<LINE>", "lock opened!@"
	db TX_END

;@ path: data/text/text_2
_VermilionGymTrashSuccessText2::
	db TX_START, "Hey! There's"
	db "<LINE>", "another switch"
	db "<CONT>", "under the trash!"
	db "<CONT>", "Turn it on!"
	db "<PROMPT>"

;@ path: data/text/text_2
_VermilionGymTrashSuccessText3::
	db TX_START, "The 2nd electric"
	db "<LINE>", "lock opened!"

	db "<PARA>", "The motorized door"
	db "<LINE>", "opened!@"
	db TX_END

;@ path: data/text/text_2
_VermilionGymTrashFailText::
	db TX_START, "Nope! There's"
	db "<LINE>", "only trash here."
	db "<CONT>", "Hey! The electric"
	db "<CONT>", "locks were reset!@"
	db TX_END

;@ path: data/text/text_2
_FoundHiddenItemText::
	db TX_START, "<PLAYER> found"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_2
_HiddenItemBagFullText::
	db TX_START, "But, <PLAYER> has"
	db "<LINE>", "no more room for"
	db "<CONT>", "other items!"
	db "<DONE>"

;@ path: data/text/text_2
_FoundHiddenCoinsText::
	db TX_START, "<PLAYER> found"
	db "<LINE>", "@"
	db TX_BCD
	dw hCoins
	db 2 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START, " coins!@"
	db TX_END

;@ path: data/text/text_2
_FoundHiddenCoins2Text::
	db TX_START, "<PLAYER> found"
	db "<LINE>", "@"
	db TX_BCD
	dw hCoins
	db 2 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START, " coins!@"
	db TX_END

;@ path: data/text/text_2
_DroppedHiddenCoinsText::
	db TX_START

	db "<PARA>", "Oops! Dropped"
	db "<LINE>", "some coins!"
	db "<DONE>"

;@ path: data/text/text_2
_IndigoPlateauStatuesText1::
	db TX_START, "INDIGO PLATEAU"
	db "<PROMPT>"

;@ path: data/text/text_2
_IndigoPlateauStatuesText2::
	db TX_START, "The ultimate goal"
	db "<LINE>", "of trainers!"
	db "<CONT>", "#MON LEAGUE HQ"
	db "<DONE>"

;@ path: data/text/text_2
_IndigoPlateauStatuesText3::
	db TX_START, "The highest"
	db "<LINE>", "#MON authority"
	db "<CONT>", "#MON LEAGUE HQ"
	db "<DONE>"

;@ path: data/text/text_2
_PokemonBooksText::
	db TX_START, "Crammed full of"
	db "<LINE>", "#MON books!"
	db "<DONE>"

;@ path: data/text/text_2
_DiglettSculptureText::
	db TX_START, "It's a sculpture"
	db "<LINE>", "of DIGLETT."
	db "<DONE>"

;@ path: data/text/text_2
_ElevatorText::
	db TX_START, "This is an"
	db "<LINE>", "elevator."
	db "<DONE>"

;@ path: data/text/text_2
_TownMapText::
	db TX_START, "A TOWN MAP.@"
	db TX_END

;@ path: data/text/text_2
_PokemonStuffText::
	db TX_START, "Wow! Tons of"
	db "<LINE>", "#MON stuff!"
	db "<DONE>"

;@ path: data/text/text_2
_OutOfSafariBallsText::
	db TX_START, "PA: Ding-dong!"

	db "<PARA>", "You are out of"
	db "<LINE>", "SAFARI BALLs!"
	db "<PROMPT>"

;@ path: data/text/text_2
_WildRanText::
	db TX_START, "Wild @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "ran!"
	db "<PROMPT>"

;@ path: data/text/text_2
_EnemyRanText::
	db TX_START, "Enemy @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "ran!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HurtByPoisonText::
	db TX_START, "<USER>'s"
	db "<LINE>", "hurt by poison!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HurtByBurnText::
	db TX_START, "<USER>'s"
	db "<LINE>", "hurt by the burn!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HurtByLeechSeedText::
	db TX_START, "LEECH SEED saps"
	db "<LINE>", "<USER>!"
	db "<PROMPT>"

;@ path: data/text/text_2
_EnemyMonFaintedText::
	db TX_START, "Enemy @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "fainted!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MoneyForWinningText::
	db TX_START, "<PLAYER> got ¥@"
	db TX_BCD
	dw wAmountMoneyWon
	db 3 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START
	db "<LINE>", "for winning!"
	db "<PROMPT>"

;@ path: data/text/text_2
_TrainerDefeatedText::
	db TX_START, "<PLAYER> defeated"
	db "<LINE>", "@"
	db TX_RAM
	dw wTrainerName
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_2
_PlayerMonFaintedText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START
	db "<LINE>", "fainted!"
	db "<PROMPT>"

;@ path: data/text/text_2
_UseNextMonText::
	db TX_START, "Use next #MON?"
	db "<DONE>"

;@ path: data/text/text_2
_Rival1WinText::
	db TX_START, "<RIVAL>: Yeah! Am"
	db "<LINE>", "I great or what?"
	db "<PROMPT>"

;@ path: data/text/text_2
_PlayerBlackedOutText2::
	db TX_START, "<PLAYER> is out of"
	db "<LINE>", "useable #MON!"

	db "<PARA>", "<PLAYER> blacked"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: data/text/text_2
_LinkBattleLostText::
	db TX_START, "<PLAYER> lost to"
	db "<LINE>", "@"
	db TX_RAM
	dw wTrainerName
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_2
_TrainerAboutToUseText::
	db TX_RAM
	dw wTrainerName
	db TX_START, " is"
	db "<LINE>", "about to use"
	db "<CONT>", "@"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START, "!"

	db "<PARA>", "Will <PLAYER>"
	db "<LINE>", "change #MON?"
	db "<DONE>"

;@ path: data/text/text_2
_TrainerSentOutText::
	db TX_RAM
	dw wTrainerName
	db TX_START, " sent"
	db "<LINE>", "out @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_NoWillText::
	db TX_START, "There's no will"
	db "<LINE>", "to fight!"
	db "<PROMPT>"

;@ path: data/text/text_2
_CantEscapeText::
	db TX_START, "Can't escape!"
	db "<PROMPT>"

;@ path: data/text/text_2
_NoRunningText::
	db TX_START, "No! There's no"
	db "<LINE>", "running from a"
	db "<CONT>", "trainer battle!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GotAwayText::
	db TX_START, "Got away safely!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ItemsCantBeUsedHereText::
	db TX_START, "Items can't be"
	db "<LINE>", "used here."
	db "<PROMPT>"

;@ path: data/text/text_2
_AlreadyOutText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " is"
	db "<LINE>", "already out!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MoveNoPPText::
	db TX_START, "No PP left for"
	db "<LINE>", "this move!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MoveDisabledText::
	db TX_START, "The move is"
	db "<LINE>", "disabled!"
	db "<PROMPT>"

;@ path: data/text/text_2
_NoMovesLeftText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " has no"
	db "<LINE>", "moves left!"
	db "<DONE>"

;@ path: data/text/text_2
_MultiHitText::
	db TX_START, "Hit the enemy"
	db "<LINE>", "@"
	db TX_NUM
	dw wPlayerNumHits
	db ((1) << 4) | (1)
	db TX_START, " times!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ScaredText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " is too"
	db "<LINE>", "scared to move!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GetOutText::
	db TX_START, "GHOST: Get out..."
	db "<LINE>", "Get out..."
	db "<PROMPT>"

;@ path: data/text/text_2
_FastAsleepText::
	db TX_START, "<USER>"
	db "<LINE>", "is fast asleep!"
	db "<PROMPT>"

;@ path: data/text/text_2
_WokeUpText::
	db TX_START, "<USER>"
	db "<LINE>", "woke up!"
	db "<PROMPT>"

;@ path: data/text/text_2
_IsFrozenText::
	db TX_START, "<USER>"
	db "<LINE>", "is frozen solid!"
	db "<PROMPT>"

;@ path: data/text/text_2
_FullyParalyzedText::
	db TX_START, "<USER>'s"
	db "<LINE>", "fully paralyzed!"
	db "<PROMPT>"

;@ path: data/text/text_2
_FlinchedText::
	db TX_START, "<USER>"
	db "<LINE>", "flinched!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MustRechargeText::
	db TX_START, "<USER>"
	db "<LINE>", "must recharge!"
	db "<PROMPT>"

;@ path: data/text/text_2
_DisabledNoMoreText::
	db TX_START, "<USER>'s"
	db "<LINE>", "disabled no more!"
	db "<PROMPT>"

;@ path: data/text/text_2
_IsConfusedText::
	db TX_START, "<USER>"
	db "<LINE>", "is confused!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HurtItselfText::
	db TX_START, "It hurt itself in"
	db "<LINE>", "its confusion!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ConfusedNoMoreText::
	db TX_START, "<USER>'s"
	db "<LINE>", "confused no more!"
	db "<PROMPT>"

;@ path: data/text/text_2
_SavingEnergyText::
	db TX_START, "<USER>"
	db "<LINE>", "is saving energy!"
	db "<PROMPT>"

;@ path: data/text/text_2
_UnleashedEnergyText::
	db TX_START, "<USER>"
	db "<LINE>", "unleashed energy!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ThrashingAboutText::
	db TX_START, "<USER>'s"
	db "<LINE>", "thrashing about!"
	db "<DONE>"

;@ path: data/text/text_2
_AttackContinuesText::
	db TX_START, "<USER>'s"
	db "<LINE>", "attack continues!"
	db "<DONE>"

;@ path: data/text/text_2
_CantMoveText::
	db TX_START, "<USER>"
	db "<LINE>", "can't move!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MoveIsDisabledText::
	db TX_START, "<USER>'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, " is"
	db "<CONT>", "disabled!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ActorNameText::
	db TX_START, "<USER>@"
	db TX_END

;@ path: data/text/text_2
_UsedMove1Text::
	db TX_START
	db "<LINE>", "used @"
	db TX_END

;@ path: data/text/text_2
_UsedMove2Text::
	db TX_START
	db "<LINE>", "used @"
	db TX_END

;@ path: data/text/text_2
_UsedInsteadText::
	db TX_START, "instead,"
	db "<CONT>", "@"
	db TX_END

;@ path: data/text/text_2
_MoveNameText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, "@"

;@ path: data/text/text_2
_EndUsedMove1Text::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_EndUsedMove2Text::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_EndUsedMove3Text::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_EndUsedMove4Text::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_EndUsedMove5Text::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_AttackMissedText::
	db TX_START, "<USER>'s"
	db "<LINE>", "attack missed!"
	db "<PROMPT>"

;@ path: data/text/text_2
_KeptGoingAndCrashedText::
	db TX_START, "<USER>"
	db "<LINE>", "kept going and"
	db "<CONT>", "crashed!"
	db "<PROMPT>"

;@ path: data/text/text_2
_UnaffectedText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "unaffected!"
	db "<PROMPT>"

;@ path: data/text/text_2
_DoesntAffectMonText::
	db TX_START, "It doesn't affect"
	db "<LINE>", "<TARGET>!"
	db "<PROMPT>"

;@ path: data/text/text_2
_CriticalHitText::
	db TX_START, "Critical hit!"
	db "<PROMPT>"

;@ path: data/text/text_2
_OHKOText::
	db TX_START, "One-hit KO!"
	db "<PROMPT>"

;@ path: data/text/text_2
_LoafingAroundText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " is"
	db "<LINE>", "loafing around."
	db "<PROMPT>"

;@ path: data/text/text_2
_BeganToNapText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " began"
	db "<LINE>", "to nap!"
	db "<PROMPT>"

;@ path: data/text/text_2
_WontObeyText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " won't"
	db "<LINE>", "obey!"
	db "<PROMPT>"

;@ path: data/text/text_2
_TurnedAwayText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " turned"
	db "<LINE>", "away!"
	db "<PROMPT>"

;@ path: data/text/text_2
_IgnoredOrdersText::
	db TX_RAM
	dw wBattleMonNick
	db TX_START
	db "<LINE>", "ignored orders!"
	db "<PROMPT>"

;@ path: data/text/text_2
_SubstituteTookDamageText::
	db TX_START, "The SUBSTITUTE"
	db "<LINE>", "took damage for"
	db "<CONT>", "<TARGET>!"
	db "<PROMPT>"

;@ path: data/text/text_2
_SubstituteBrokeText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "SUBSTITUTE broke!"
	db "<PROMPT>"

;@ path: data/text/text_2
_BuildingRageText::
	db TX_START, "<USER>'s"
	db "<LINE>", "RAGE is building!"
	db "<PROMPT>"

;@ path: data/text/text_2
_MirrorMoveFailedText::
	db TX_START, "The MIRROR MOVE"
	db "<NEXT>", "failed!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HitXTimesText::
	db TX_START, "Hit @"
	db TX_NUM
	dw wEnemyNumHits
	db ((1) << 4) | (1)
	db TX_START, " times!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GainedText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " gained"
	db "<LINE>", "@"
	db TX_END

;@ path: data/text/text_2
_WithExpAllText::
	db TX_START, "with EXP.ALL,"
	db "<CONT>", "@"
	db TX_END

;@ path: data/text/text_2
_BoostedText::
	db TX_START, "a boosted"
	db "<CONT>", "@"
	db TX_END

;@ path: data/text/text_2
_ExpPointsText::
	db TX_NUM
	dw wExpAmountGained
	db ((2) << 4) | (4)
	db TX_START, " EXP. Points!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GrewLevelText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " grew"
	db "<LINE>", "to level @"
	db TX_NUM
	dw wCurEnemyLevel
	db ((1) << 4) | (3)
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_2
_WildMonAppearedText::
	db TX_START, "Wild @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "appeared!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HookedMonAttackedText::
	db TX_START, "The hooked"
	db "<LINE>", "@"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<CONT>", "attacked!"
	db "<PROMPT>"

;@ path: data/text/text_2
_EnemyAppearedText::
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "appeared!"
	db "<PROMPT>"

;@ path: data/text/text_2
_TrainerWantsToFightText::
	db TX_RAM
	dw wTrainerName
	db TX_START, " wants"
	db "<LINE>", "to fight!"
	db "<PROMPT>"

;@ path: data/text/text_2
_UnveiledGhostText::
	db TX_START, "SILPH SCOPE"
	db "<LINE>", "unveiled the"
	db "<CONT>", "GHOST's identity!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GhostCantBeIDdText::
	db TX_START, "Darn! The GHOST"
	db "<LINE>", "can't be ID'd!"
	db "<PROMPT>"

;@ path: data/text/text_2
_GoText::
	db TX_START, "Go! @"
	db TX_END

;@ path: data/text/text_2
_DoItText::
	db TX_START, "Do it! @"
	db TX_END

;@ path: data/text/text_2
_GetmText::
	db TX_START, "Get'm! @"
	db TX_END

;@ path: data/text/text_2
_EnemysWeakText::
	db TX_START, "The enemy's weak!"
	db "<LINE>", "Get'm! @"
	db TX_END

;@ path: data/text/text_2
_PlayerMon1Text::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_PlayerMon2Text::
	db TX_RAM
	dw wBattleMonNick
	db TX_START, " @"
	db TX_END

;@ path: data/text/text_2
_EnoughText::
	db TX_START, "enough!@"
	db TX_END

;@ path: data/text/text_2
_OKExclamationText::
	db TX_START, "OK!@"
	db TX_END

;@ path: data/text/text_2
_GoodText::
	db TX_START, "good!@"
	db TX_END

;@ path: data/text/text_2
_ComeBackText::
	db TX_START
	db "<LINE>", "Come back!"
	db "<DONE>"

;@ path: data/text/text_2
_SuperEffectiveText::
	db TX_START, "It's super"
	db "<LINE>", "effective!"
	db "<PROMPT>"

;@ path: data/text/text_2
_NotVeryEffectiveText::
	db TX_START, "It's not very"
	db "<LINE>", "effective..."
	db "<PROMPT>"

;@ path: data/text/text_2
_SafariZoneEatingText::
	db TX_START, "Wild @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "is eating!"
	db "<PROMPT>"

;@ path: data/text/text_2
_SafariZoneAngryText::
	db TX_START, "Wild @"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START
	db "<LINE>", "is angry!"
	db "<PROMPT>"

; money related
;@ path: data/text/text_2
_PickUpPayDayMoneyText::
	db TX_START, "<PLAYER> picked up"
	db "<LINE>", "¥@"
	db TX_BCD
	dw wTotalPayDayMoney
	db 3 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_2
_ClearSaveDataText::
	db TX_START, "Clear all saved"
	db "<LINE>", "data?"
	db "<DONE>"

;@ path: data/text/text_2
_WhichFloorText::
	db TX_START, "Which floor do"
	db "<LINE>", "you want? "
	db "<DONE>"

;@ path: data/text/text_2
_PartyMenuNormalText::
	db TX_START, "Choose a #MON."
	db "<DONE>"

;@ path: data/text/text_2
_PartyMenuItemUseText::
	db TX_START, "Use item on which"
	db "<LINE>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_2
_PartyMenuBattleText::
	db TX_START, "Bring out which"
	db "<LINE>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_2
_PartyMenuUseTMText::
	db TX_START, "Use TM on which"
	db "<LINE>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_2
_PartyMenuSwapMonText::
	db TX_START, "Move #MON"
	db "<LINE>", "where?"
	db "<DONE>"

;@ path: data/text/text_2
_PotionText::
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<LINE>", "recovered by @"
	db TX_NUM
	dw wHPBarHPDifference
	db ((2) << 4) | (3)
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_2
_AntidoteText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " was"
	db "<LINE>", "cured of poison!"
	db "<DONE>"

;@ path: data/text/text_2
_ParlyzHealText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, "'s"
	db "<LINE>", "rid of paralysis!"
	db "<DONE>"

;@ path: data/text/text_2
_BurnHealText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, "'s"
	db "<LINE>", "burn was healed!"
	db "<DONE>"

;@ path: data/text/text_2
_IceHealText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " was"
	db "<LINE>", "defrosted!"
	db "<DONE>"

;@ path: data/text/text_2
_AwakeningText::
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<LINE>", "woke up!"
	db "<DONE>"

;@ path: data/text/text_2
_FullHealText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, "'s"
	db "<LINE>", "health returned!"
	db "<DONE>"

;@ path: data/text/text_2
_ReviveText::
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<LINE>", "is revitalized!"
	db "<DONE>"

;@ path: data/text/text_2
_RareCandyText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " grew"
	db "<LINE>", "to level @"
	db TX_NUM
	dw wCurEnemyLevel
	db ((1) << 4) | (3)
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_2
_TurnedOnPC1Text::
	db TX_START, "<PLAYER> turned on"
	db "<LINE>", "the PC."
	db "<PROMPT>"

;@ path: data/text/text_2
_AccessedBillsPCText::
	db TX_START, "Accessed BILL's"
	db "<LINE>", "PC."

	db "<PARA>", "Accessed #MON"
	db "<LINE>", "Storage System."
	db "<PROMPT>"

;@ path: data/text/text_2
_AccessedSomeonesPCText::
	db TX_START, "Accessed someone's"
	db "<LINE>", "PC."

	db "<PARA>", "Accessed #MON"
	db "<LINE>", "Storage System."
	db "<PROMPT>"

;@ path: data/text/text_2
_AccessedMyPCText::
	db TX_START, "Accessed my PC."

	db "<PARA>", "Accessed Item"
	db "<LINE>", "Storage System."
	db "<PROMPT>"

;@ path: data/text/text_2
_TurnedOnPC2Text::
	db TX_START, "<PLAYER> turned on"
	db "<LINE>", "the PC."
	db "<PROMPT>"

;@ path: data/text/text_2
_WhatDoYouWantText::
	db TX_START, "What do you want"
	db "<LINE>", "to do?"
	db "<DONE>"

;@ path: data/text/text_2
_WhatToDepositText::
	db TX_START, "What do you want"
	db "<LINE>", "to deposit?"
	db "<DONE>"

;@ path: data/text/text_2
_DepositHowManyText::
	db TX_START, "How many?"
	db "<DONE>"

;@ path: data/text/text_2
_ItemWasStoredText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " was"
	db "<LINE>", "stored via PC."
	db "<PROMPT>"

;@ path: data/text/text_2
_NothingToDepositText::
	db TX_START, "You have nothing"
	db "<LINE>", "to deposit."
	db "<PROMPT>"

;@ path: data/text/text_2
_NoRoomToStoreText::
	db TX_START, "No room left to"
	db "<LINE>", "store items."
	db "<PROMPT>"

;@ path: data/text/text_2
_WhatToWithdrawText::
	db TX_START, "What do you want"
	db "<LINE>", "to withdraw?"
	db "<DONE>"

;@ path: data/text/text_2
_WithdrawHowManyText::
	db TX_START, "How many?"
	db "<DONE>"

;@ path: data/text/text_2
_WithdrewItemText::
	db TX_START, "Withdrew"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "."
	db "<PROMPT>"

;@ path: data/text/text_2
_NothingStoredText::
	db TX_START, "There is nothing"
	db "<LINE>", "stored."
	db "<PROMPT>"

;@ path: data/text/text_2
_CantCarryMoreText::
	db TX_START, "You can't carry"
	db "<LINE>", "any more items."
	db "<PROMPT>"

;@ path: data/text/text_2
_WhatToTossText::
	db TX_START, "What do you want"
	db "<LINE>", "to toss away?"
	db "<DONE>"

;@ path: data/text/text_2
_TossHowManyText::
	db TX_START, "How many?"
	db "<DONE>"

;@ path: data/text/text_2
_AccessedHoFPCText::
	db TX_START, "Accessed #MON"
	db "<LINE>", "LEAGUE's site."

	db "<PARA>", "Accessed the HALL"
	db "<LINE>", "OF FAME List."
	db "<PROMPT>"

;@ path: data/text/text_2
_SwitchOnText::
	db TX_START, "Switch on!"
	db "<PROMPT>"

;@ path: data/text/text_2
_WhatText::
	db TX_START, "What?"
	db "<DONE>"

;@ path: data/text/text_2
_DepositWhichMonText::
	db TX_START, "Deposit which"
	db "<LINE>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_2
_MonWasStoredText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, " was"
	db "<LINE>", "stored in Box @"
	db TX_RAM
	dw wBoxNumString
	db TX_START, "."
	db "<PROMPT>"

;@ path: data/text/text_2
_CantDepositLastMonText::
	db TX_START, "You can't deposit"
	db "<LINE>", "the last #MON!"
	db "<PROMPT>"

;@ path: data/text/text_2
_BoxFullText::
	db TX_START, "Oops! This Box is"
	db "<LINE>", "full of #MON."
	db "<PROMPT>"

;@ path: data/text/text_2
_MonIsTakenOutText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, " is"
	db "<LINE>", "taken out."
	db "<CONT>", "Got @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "."
	db "<PROMPT>"

;@ path: data/text/text_2
_NoMonText::
	db TX_START, "What? There are"
	db "<LINE>", "no #MON here!"
	db "<PROMPT>"

;@ path: data/text/text_2
_CantTakeMonText::
	db TX_START, "You can't take"
	db "<LINE>", "any more #MON."

	db "<PARA>", "Deposit #MON"
	db "<LINE>", "first."
	db "<PROMPT>"

;@ path: data/text/text_2
_ReleaseWhichMonText::
	db TX_START, "Release which"
	db "<LINE>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_2
_OnceReleasedText::
	db TX_START, "Once released,"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, " is"
	db "<CONT>", "gone forever. OK?"
	db "<DONE>"

;@ path: data/text/text_2
_MonWasReleasedText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, " was"
	db "<LINE>", "released outside."
	db "<CONT>", "Bye @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_2
_RequireCoinCaseText::
	db TX_START, "A COIN CASE is"
	db "<LINE>", "required!@"
	db TX_END

;@ path: data/text/text_2
_ExchangeCoinsForPrizesText::
	db TX_START, "We exchange your"
	db "<LINE>", "coins for prizes."
	db "<PROMPT>"

;@ path: data/text/text_2
_WhichPrizeText::
	db TX_START, "Which prize do"
	db "<LINE>", "you want?"
	db "<DONE>"

;@ path: data/text/text_2
_HereYouGoText::
	db TX_START, "Here you go!@"
	db TX_END

;@ path: data/text/text_2
_SoYouWantPrizeText::
	db TX_START, "So, you want"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "?"
	db "<DONE>"

;@ path: data/text/text_2
_SorryNeedMoreCoinsText::
	db TX_START, "Sorry, you need"
	db "<LINE>", "more coins.@"
	db TX_END

;@ path: data/text/text_2
_OopsYouDontHaveEnoughRoomText::
	db TX_START, "Oops! You don't"
	db "<LINE>", "have enough room.@"
	db TX_END

;@ path: data/text/text_2
_OhFineThenText::
	db TX_START, "Oh, fine then.@"
	db TX_END

;@ path: data/text/text_2
_GetDexRatedText::
	db TX_START, "Want to get your"
	db "<LINE>", "#DEX rated?"
	db "<DONE>"

;@ path: data/text/text_2
_ClosedOaksPCText::
	db TX_START, "Closed link to"
	db "<LINE>", "PROF.OAK's PC.@"
	db TX_END

;@ path: data/text/text_2
_AccessedOaksPCText::
	db TX_START, "Accessed PROF."
	db "<LINE>", "OAK's PC."

	db "<PARA>", "Accessed #DEX"
	db "<LINE>", "Rating System."
	db "<PROMPT>"

;@ path: data/text/text_2
_WhereWouldYouLikeText::
	db TX_START, "Where would you"
	db "<LINE>", "like to go?"
	db "<DONE>"

;@ path: data/text/text_2
_PleaseWaitText::
	db TX_START, "OK, please wait"
	db "<LINE>", "just a moment."
	db "<DONE>"

;@ path: data/text/text_2
_LinkCanceledText::
	db TX_START, "The link was"
	db "<LINE>", "canceled."
	db "<DONE>"

;@ path: data/text/text_2
_OakSpeechText1::
	db TX_START, "Hello there!"
	db "<LINE>", "Welcome to the"
	db "<CONT>", "world of #MON!"

	db "<PARA>", "My name is OAK!"
	db "<LINE>", "People call me"
	db "<CONT>", "the #MON PROF!"
	db "<PROMPT>"

;@ path: data/text/text_2
_OakSpeechText2A::
	db TX_START, "This world is"
	db "<LINE>", "inhabited by"
	db "<CONT>", "creatures called"
	db "<CONT>", "#MON!@"
	db TX_END

;@ path: data/text/text_2
_OakSpeechText2B::
	db TX_START

	db "<PARA>", "For some people,"
	db "<LINE>", "#MON are"
	db "<CONT>", "pets. Others use"
	db "<CONT>", "them for fights."

	db "<PARA>", "Myself..."

	db "<PARA>", "I study #MON"
	db "<LINE>", "as a profession."
	db "<PROMPT>"

;@ path: data/text/text_2
_IntroducePlayerText::
	db TX_START, "First, what is"
	db "<LINE>", "your name?"
	db "<PROMPT>"

;@ path: data/text/text_2
_IntroduceRivalText::
	db TX_START, "This is my grand-"
	db "<LINE>", "son. He's been"
	db "<CONT>", "your rival since"
	db "<CONT>", "you were a baby."

	db "<PARA>", "...Erm, what is"
	db "<LINE>", "his name again?"
	db "<PROMPT>"

;@ path: data/text/text_2
_OakSpeechText3::
	db TX_START, "<PLAYER>!"

	db "<PARA>", "Your very own"
	db "<LINE>", "#MON legend is"
	db "<CONT>", "about to unfold!"

	db "<PARA>", "A world of dreams"
	db "<LINE>", "and adventures"
	db "<CONT>", "with #MON"
	db "<CONT>", "awaits! Let's go!"
	db "<DONE>"

;@ path: data/text/text_2
_DoYouWantToNicknameText::
	db TX_START, "Do you want to"
	db "<LINE>", "give a nickname"
	db "<CONT>", "to @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "?"
	db "<DONE>"

;@ path: data/text/text_2
_YourNameIsText::
	db TX_START, "Right! So your"
	db "<LINE>", "name is <PLAYER>!"
	db "<PROMPT>"

;@ path: data/text/text_2
_HisNameIsText::
	db TX_START, "That's right! I"
	db "<LINE>", "remember now! His"
	db "<CONT>", "name is <RIVAL>!"
	db "<PROMPT>"

;@ path: data/text/text_2
_WillBeTradedText::
	db TX_RAM
	dw wNameOfPlayerMonToBeTraded
	db TX_START, " and"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, " will"
	db "<CONT>", "be traded."
	db "<DONE>"

;@ path: data/text/text_2
_TextIDErrorText::
	db TX_NUM
	dw hTextID
	db ((1) << 4) | (2)
	db TX_START, " ERROR."
	db "<DONE>"

;@ path: data/text/text_2
_ContCharText::
	db TX_START, "<_CONT>@"
	db TX_END

;@ path: text/DiglettsCaveRoute2
_DiglettsCaveRoute2FishingGuruText::
	db TX_START, "I went to ROCK"
	db "<LINE>", "TUNNEL, but it's"
	db "<CONT>", "dark and scary."

	db "<PARA>", "If a #MON's"
	db "<LINE>", "FLASH could light"
	db "<CONT>", "it up..."
	db "<DONE>"
;@ path: text/ViridianForestNorthGate
_ViridianForestNorthGateSuperNerdText::
	db TX_START, "Many #MON live"
	db "<LINE>", "only in forests "
	db "<CONT>", "and caves."

	db "<PARA>", "You need to look"
	db "<LINE>", "everywhere to get"
	db "<CONT>", "different kinds!"
	db "<DONE>"

;@ path: text/ViridianForestNorthGate
_ViridianForestNorthGateGrampsText::
	db TX_START, "Have you noticed"
	db "<LINE>", "the bushes on the"
	db "<CONT>", "roadside?"

	db "<PARA>", "They can be cut"
	db "<LINE>", "down by a special"
	db "<CONT>", "#MON move."
	db "<DONE>"
;@ path: text/Route2TradeHouse
_Route2TradeHouseScientistText::
	db TX_START, "A fainted #MON"
	db "<LINE>", "can't fight. But, "
	db "<CONT>", "it can still use "
	db "<CONT>", "moves like CUT!"
	db "<DONE>"
;@ path: text/Route2Gate
_Route2GateOaksAideFlashExplanationText::
	db TX_START, "The HM FLASH"
	db "<LINE>", "lights even the"
	db "<CONT>", "darkest dungeons."
	db "<DONE>"

;@ path: text/Route2Gate
_Route2GateYoungsterText::
	db TX_START, "Once a #MON"
	db "<LINE>", "learns FLASH, you"
	db "<CONT>", "can get through"
	db "<CONT>", "ROCK TUNNEL."
	db "<DONE>"
;@ path: text/ViridianForestSouthGate
_ViridianForestSouthGateGirlText::
	db TX_START, "Are you going to"
	db "<LINE>", "VIRIDIAN FOREST?"
	db "<CONT>", "Be careful, it's"
	db "<CONT>", "a natural maze!"
	db "<DONE>"

;@ path: text/ViridianForestSouthGate
_ViridianForestSouthGateLittleGirlText::
	db TX_START, "RATTATA may be"
	db "<LINE>", "small, but its"
	db "<CONT>", "bite is wicked!"
	db "<CONT>", "Did you get one?"
	db "<DONE>"
;@ path: text/MtMoonPokecenter
_MtMoonPokecenterYoungsterText::
	db TX_START, "I've 6 # BALLs"
	db "<LINE>", "set in my belt."

	db "<PARA>", "At most, you can"
	db "<LINE>", "carry 6 #MON."
	db "<DONE>"

;@ path: text/MtMoonPokecenter
_MtMoonPokecenterGentlemanText::
	db TX_START, "TEAM ROCKET"
	db "<LINE>", "attacks CERULEAN"
	db "<CONT>", "citizens..."

	db "<PARA>", "TEAM ROCKET is"
	db "<LINE>", "always in the"
	db "<CONT>", "news!"
	db "<DONE>"

;@ path: text/MtMoonPokecenter
_MtMoonPokecenterMagikarpSalesmanIGotADealText::
	db TX_START, "MAN: Hello, there!"
	db "<LINE>", "Have I got a deal"
	db "<CONT>", "just for you!"

	db "<PARA>", "I'll let you have"
	db "<LINE>", "a swell MAGIKARP"
	db "<CONT>", "for just ¥500!"
	db "<CONT>", "What do you say?"
	db "<DONE>"

;@ path: text/MtMoonPokecenter
_MtMoonPokecenterMagikarpSalesmanNoText::
	db TX_START, "No? I'm only"
	db "<LINE>", "doing this as a"
	db "<CONT>", "favor to you!"
	db "<DONE>"

;@ path: text/MtMoonPokecenter
_MtMoonPokecenterMagikarpSalesmanNoMoneyText::
	db TX_START, "You'll need more"
	db "<LINE>", "money than that!"
	db "<DONE>"

;@ path: text/MtMoonPokecenter
_MtMoonPokecenterMagikarpSalesmanNoRefundsText::
	db TX_START, "MAN: Well, I don't"
	db "<LINE>", "give refunds!"
	db "<DONE>"

;@ path: text/MtMoonPokecenter
_MtMoonPokecenterClipboardText::
	db TX_START
	db "<DONE>"
;@ path: text/SaffronGates
_SaffronGateGuardGeeImThirstyText::
	db TX_START, "I'm on guard duty."
	db "<LINE>", "Gee, I'm thirsty,"
	db "<CONT>", "though!"

	db "<PARA>", "Oh wait there,"
	db "<LINE>", "the road's closed."
	db "<DONE>"

;@ path: text/SaffronGates
_SaffronGateGuardImParchedText::
	db TX_START, "Whoa, boy!"
	db "<LINE>", "I'm parched!"
	db "<CONT>", "..."
	db "<CONT>", "Huh? I can have"
	db "<CONT>", "this drink?"
	db "<CONT>", "Gee, thanks!@"
	db TX_END

;@ path: text/SaffronGates
_SaffronGateGuardYouCanGoOnThroughText::
	db TX_START

	db "<PARA>", "..."
	db "<LINE>", "Glug glug..."
	db "<CONT>", "..."
	db "<CONT>", "Gulp..."
	db "<CONT>", "If you want to go"
	db "<CONT>", "to SAFFRON CITY..."
	db "<CONT>", "..."
	db "<CONT>", "You can go on"
	db "<CONT>", "through. I'll"
	db "<CONT>", "share this with"
	db "<CONT>", "the other guards!"
	db "<DONE>"

;@ path: text/SaffronGates
_SaffronGateGuardThanksForTheDrinkText::
	db TX_START, "Hi, thanks for"
	db "<LINE>", "the cool drinks!"
	db "<DONE>"
;@ path: text/Daycare
_DaycareGentlemanIntroText::
	db TX_START, "I run a DAYCARE."
	db "<LINE>", "Would you like me"
	db "<CONT>", "to raise one of"
	db "<CONT>", "your #MON?"
	db "<DONE>"

;@ path: text/Daycare
_DaycareGentlemanWhichMonText::
	db TX_START, "Which #MON"
	db "<LINE>", "should I raise?"
	db "<PROMPT>"

;@ path: text/Daycare
_DaycareGentlemanWillLookAfterMonText::
	db TX_START, "Fine, I'll look"
	db "<LINE>", "after @"
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<CONT>", "for a while."
	db "<PROMPT>"

;@ path: text/Daycare
_DaycareGentlemanComeSeeMeInAWhileText::
	db TX_START, "Come see me in"
	db "<LINE>", "a while."
	db "<DONE>"

;@ path: text/Daycare
_DaycareGentlemanMonHasGrownText::
	db TX_START, "Your @"
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<LINE>", "has grown a lot!"

	db "<PARA>", "By level, it's"
	db "<LINE>", "grown by @"
	db TX_NUM
	dw wDayCareNumLevelsGrown
	db ((1) << 4) | (3)
	db TX_START, "!"

	db "<PARA>", "Aren't I great?"
	db "<PROMPT>"

;@ path: text/Daycare
_DaycareGentlemanOweMoneyText::
	db TX_START, "You owe me ¥@"
	db TX_BCD
	dw wDayCareTotalCost
	db 2 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START
	db "<LINE>", "for the return"
	db "<CONT>", "of this #MON."
	db "<DONE>"

;@ path: text/Daycare
_DaycareGentlemanGotMonBackText::
	db TX_START, "<PLAYER> got"
	db "<LINE>", "@"
	db TX_RAM
	dw wDayCareMonName
	db TX_START, " back!"
	db "<DONE>"

;@ path: text/Daycare
_DaycareGentlemanMonNeedsMoreTimeText::
	db TX_START, "Back already?"
	db "<LINE>", "Your @"
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<CONT>", "needs some more"
	db "<CONT>", "time with me."
	db "<PROMPT>"


SECTION "Text 4", ROMX

;@ path: text/Daycare_2
_DaycareGentlemanAllRightThenText::
	db TX_START, "All right then,"
	db "<LINE>", "@"
	db TX_END

;@ path: text/Daycare_2
_DaycareGentlemanComeAgainText::
	db TX_START, "come again."
	db "<DONE>"

;@ path: text/Daycare_2
_DaycareGentlemanNoRoomForMonText::
	db TX_START, "You have no room"
	db "<LINE>", "for this #MON!"
	db "<DONE>"

;@ path: text/Daycare_2
_DaycareGentlemanOnlyHaveOneMonText::
	db TX_START, "You only have one"
	db "<LINE>", "#MON with you."
	db "<DONE>"

;@ path: text/Daycare_2
_DaycareGentlemanCantAcceptMonWithHMText::
	db TX_START, "I can't accept a"
	db "<LINE>", "#MON that"
	db "<CONT>", "knows an HM move."
	db "<DONE>"

;@ path: text/Daycare_2
_DaycareGentlemanHeresYourMonText::
	db TX_START, "Thank you! Here's"
	db "<LINE>", "your #MON!"
	db "<PROMPT>"

;@ path: text/Daycare_2
_DaycareGentlemanNotEnoughMoneyText::
	db TX_START, "Hey, you don't"
	db "<LINE>", "have enough ¥!"
	db "<DONE>"
;@ path: text/UndergroundPathRoute6
_UndergroundPathRoute6GirlText::
	db TX_START, "People often lose"
	db "<LINE>", "things in that"
	db "<CONT>", "UNDERGROUND PATH."
	db "<DONE>"
;@ path: text/UndergroundPathRoute7
_UndergroundPathRoute7MiddleAgedManText::
	db TX_START, "I heard a sleepy"
	db "<LINE>", "#MON appeared"
	db "<CONT>", "near CELADON CITY."
	db "<DONE>"
;@ path: text/UndergroundPathRoute7Copy
_UndergroundPathRoute7CopyUnusedGirlText::
	db TX_START, "I want to shop at"
	db "<LINE>", "the dept. store"
	db "<CONT>", "in CELADON but..."

	db "<PARA>", "There are so many"
	db "<LINE>", "rough looking"
	db "<CONT>", "people there."
	db "<DONE>"

;@ path: text/UndergroundPathRoute7Copy
_UndergroundPathRoute7CopyUnusedTeamRocketHadAHideoutText::
	db TX_START, "TEAM ROCKET had a"
	db "<LINE>", "secret hideout in"
	db "<CONT>", "CELADON CITY?"
	db "<DONE>"

;@ path: text/UndergroundPathRoute7Copy
_UndergroundPathRoute7CopyUnusedMiddleAgedManText::
	db TX_START, "You're here to"
	db "<LINE>", "shop in CELADON?"

	db "<PARA>", "Just step outside"
	db "<LINE>", "and head west!"
	db "<DONE>"

;@ path: text/UndergroundPathRoute7Copy
_UndergroundPathRoute7CopyUnusedGoesUnderSaffronText::
	db TX_START, "The UNDERGROUND"
	db "<LINE>", "PATH goes beneath"
	db "<CONT>", "SAFFRON and leads"
	db "<CONT>", "to LAVENDER."

	db "<PARA>", "If you're heading"
	db "<LINE>", "to CERULEAN, go"
	db "<CONT>", "to the building"
	db "<CONT>", "across the road."
	db "<DONE>"
;@ path: text/UndergroundPathRoute8
_UndergroundPathRoute8GirlText::
	db TX_START, "The dept. store"
	db "<LINE>", "in CELADON has a"
	db "<CONT>", "great selection!"
	db "<DONE>"
;@ path: text/RockTunnelPokecenter
_RockTunnelPokecenterGentlemanText::
	db TX_START, "The element types"
	db "<LINE>", "of #MON make"
	db "<CONT>", "them stronger"
	db "<CONT>", "than some types"
	db "<CONT>", "and weaker than"
	db "<CONT>", "others!"
	db "<DONE>"

;@ path: text/RockTunnelPokecenter
_RockTunnelPokecenterFisherText::
	db TX_START, "I sold a useless"
	db "<LINE>", "NUGGET for ¥5000!"
	db "<DONE>"
;@ path: text/RockTunnel1F
_RockTunnel1FHiker1BattleText::
	db TX_START, "This tunnel goes"
	db "<LINE>", "a long way, kid!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker1EndBattleText::
	db TX_START, "Doh!"
	db "<LINE>", "You win!"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker1AfterBattleText::
	db TX_START, "Watch for ONIX!"
	db "<LINE>", "It can put the"
	db "<CONT>", "squeeze on you!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker2BattleText::
	db TX_START, "Hmm. Maybe I'm"
	db "<LINE>", "lost in here..."
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker2EndBattleText::
	db TX_START, "Ease up!"
	db "<LINE>", "What am I doing?"
	db "<CONT>", "Which way is out?"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker2AfterBattleText::
	db TX_START, "That sleeping"
	db "<LINE>", "#MON on ROUTE"
	db "<CONT>", "12 forced me to"
	db "<CONT>", "take this detour."
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker3BattleText::
	db TX_START, "Outsiders like"
	db "<LINE>", "you need to show"
	db "<CONT>", "me some respect!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker3EndBattleText::
	db TX_START, "I give!"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FHiker3AfterBattleText::
	db TX_START, "You're talented"
	db "<LINE>", "enough to hike!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FSuperNerdBattleText::
	db TX_START, "#MON fight!"
	db "<LINE>", "Ready, go!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FSuperNerdEndBattleText::
	db TX_START, "Game"
	db "<LINE>", "over!"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FSuperNerdAfterBattleText::
	db TX_START, "Oh well, I'll get"
	db "<LINE>", "a ZUBAT as I go!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF1BattleText::
	db TX_START, "Eek! Don't try"
	db "<LINE>", "anything funny in"
	db "<CONT>", "the dark!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF1EndBattleText::
	db TX_START, "It"
	db "<LINE>", "was too dark!"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF1AfterBattleText::
	db TX_START, "I saw a MACHOP"
	db "<LINE>", "in this tunnel!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF2BattleText::
	db TX_START, "I came this far"
	db "<LINE>", "for #MON!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF2EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "out of #MON!"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF2AfterBattleText::
	db TX_START, "You looked cute"
	db "<LINE>", "and harmless!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF3BattleText::
	db TX_START, "You have #MON!"
	db "<LINE>", "Let's start!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF3EndBattleText::
	db TX_START, "You"
	db "<LINE>", "play hard!"
	db "<PROMPT>"

;@ path: text/RockTunnel1F
_RockTunnel1FCooltrainerF3AfterBattleText::
	db TX_START, "Whew! I'm all"
	db "<LINE>", "sweaty now!"
	db "<DONE>"

;@ path: text/RockTunnel1F
_RockTunnel1FSignText::
	db TX_START, "ROCK TUNNEL"
	db "<LINE>", "CERULEAN CITY -"
	db "<CONT>", "LAVENDER TOWN"
	db "<DONE>"
;@ path: text/PowerPlant
_PowerPlantVoltorbBattleText::
	db TX_START, "Bzzzt!"
	db "<DONE>"

;@ path: text/PowerPlant
_PowerPlantZapdosBattleText::
	db TX_START, "Gyaoo!@"
	db TX_END
;@ path: text/Route11Gate1F
_Route11Gate1FGuardText::
	db TX_START, "When you catch"
	db "<LINE>", "lots of #MON,"
	db "<CONT>", "isn't it hard to"
	db "<CONT>", "think up names?"

	db "<PARA>", "In LAVENDER TOWN,"
	db "<LINE>", "there's a man who"
	db "<CONT>", "rates #MON"
	db "<CONT>", "nicknames."

	db "<PARA>", "He'll help you"
	db "<LINE>", "rename them too!"
	db "<DONE>"
;@ path: text/Route11Gate2F
_Route11Gate2FOaksAideItemfinderDescriptionText::
	db TX_START, "There are items on"
	db "<LINE>", "the ground that"
	db "<CONT>", "can't be seen."

	db "<PARA>", "ITEMFINDER will"
	db "<LINE>", "detect an item"
	db "<CONT>", "close to you."

	db "<PARA>", "It can't pinpoint"
	db "<LINE>", "it, so you have"
	db "<CONT>", "to look yourself!"
	db "<DONE>"

;@ path: text/Route11Gate2F
_Route11Gate2FLeftBinocularsSnorlaxText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "A big #MON is"
	db "<LINE>", "asleep on a road!"
	db "<DONE>"

;@ path: text/Route11Gate2F
_Route11Gate2FLeftBinocularsNoSnorlaxText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "It's a beautiful"
	db "<LINE>", "view!"
	db "<DONE>"

;@ path: text/Route11Gate2F
_Route11Gate2FRightBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "The only way to"
	db "<LINE>", "get from CERULEAN"
	db "<CONT>", "CITY to LAVENDER"
	db "<CONT>", "is by way of the"
	db "<CONT>", "ROCK TUNNEL."
	db "<DONE>"
;@ path: text/DiglettsCaveRoute11
_DiglettsCaveRoute11GamblerText::
	db TX_START, "What a surprise!"
	db "<LINE>", "DIGLETTs dug this"
	db "<CONT>", "long tunnel!"

	db "<PARA>", "It goes right to"
	db "<LINE>", "VIRIDIAN CITY!"
	db "<DONE>"
;@ path: text/Route12Gate1F
_Route12Gate1FGuardText::
	db TX_START, "There's a lookout"
	db "<LINE>", "spot upstairs."
	db "<DONE>"
;@ path: text/Route12Gate2F
_Route12Gate2FBrunetteGirlYouCanHaveThisText::
	db TX_START, "My #MON's"
	db "<LINE>", "ashes are stored"
	db "<CONT>", "in #MON TOWER."

	db "<PARA>", "You can have this"
	db "<LINE>", "TM. I don't need"
	db "<CONT>", "it any more..."
	db "<PROMPT>"

;@ path: text/Route12Gate2F
_Route12Gate2FBrunetteGirlReceivedTM39Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM39!@"
	db TX_END

;@ path: text/Route12Gate2F
_Route12Gate2FBrunetteGirlTM39ExplanationText::
	db TX_START, "TM39 is a move"
	db "<LINE>", "called SWIFT."

	db "<PARA>", "It's very accurate,"
	db "<LINE>", "so use it during"
	db "<CONT>", "battles you can't"
	db "<CONT>", "afford to lose."
	db "<DONE>"

;@ path: text/Route12Gate2F
_Route12Gate2FBrunetteGirlTM39NoRoomText::
	db TX_START, "You don't have"
	db "<LINE>", "room for this."
	db "<DONE>"

;@ path: text/Route12Gate2F
_Route12Gate2FLeftBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "A man fishing!"
	db "<DONE>"

;@ path: text/Route12Gate2F
_Route12Gate2FRightBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "It's #MON TOWER!"
	db "<DONE>"
;@ path: text/Route12SuperRodHouse
_Route12SuperRodHouseFishingGuruDoYouLikeToFishText::
	db TX_START, "I'm the FISHING"
	db "<LINE>", "GURU's brother!"

	db "<PARA>", "I simply Looove"
	db "<LINE>", "fishing!"

	db "<PARA>", "Do you like to"
	db "<LINE>", "fish?"
	db "<DONE>"

;@ path: text/Route12SuperRodHouse
_Route12SuperRodHouseFishingGuruReceivedSuperRodText::
	db TX_START, "Grand! I like"
	db "<LINE>", "your style!"

	db "<PARA>", "Take this and"
	db "<LINE>", "fish, young one!"

	db "<PARA>", "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/Route12SuperRodHouse
_Route12SuperRodHouseFishingGuruFishingWayOfLifeText::
	db TX_START

	db "<PARA>", "Fishing is a way"
	db "<LINE>", "of life!"

	db "<PARA>", "From the seas to"
	db "<LINE>", "rivers, go out"
	db "<CONT>", "and land the big"
	db "<CONT>", "one!"
	db "<DONE>"

;@ path: text/Route12SuperRodHouse
_Route12SuperRodHouseFishingGuruThatsDisappointingText::
	db TX_START, "Oh... That's so"
	db "<LINE>", "disappointing..."
	db "<DONE>"

;@ path: text/Route12SuperRodHouse
_Route12SuperRodHouseFishingGuruTryFishingText::
	db TX_START, "Hello there,"
	db "<LINE>", "<PLAYER>!"

	db "<PARA>", "Use the SUPER ROD"
	db "<LINE>", "in any water!"
	db "<CONT>", "You can catch"
	db "<CONT>", "different kinds"
	db "<CONT>", "of #MON."

	db "<PARA>", "Try fishing"
	db "<LINE>", "wherever you can!"
	db "<DONE>"

;@ path: text/Route12SuperRodHouse
_Route12SuperRodHouseFishingGuruNoRoomText::
	db TX_START, "Oh no!"

	db "<PARA>", "I had a gift for"
	db "<LINE>", "you, but you have"
	db "<CONT>", "no room for it!"
	db "<DONE>"
;@ path: text/Route15Gate1F
_Route15Gate1FGuardText::
	db TX_START, "Are you working"
	db "<LINE>", "on a #DEX?"

	db "<PARA>", "PROF.OAK's AIDE"
	db "<LINE>", "came by here."
	db "<DONE>"
;@ path: text/Route15Gate2F
_Route15Gate2FOaksAideExpAllText::
	db TX_START, "EXP.ALL gives"
	db "<LINE>", "EXP points to all"
	db "<CONT>", "the #MON with"
	db "<CONT>", "you, even if they"
	db "<CONT>", "don't fight."

	db "<PARA>", "It does, however,"
	db "<LINE>", "reduce the amount"
	db "<CONT>", "of EXP for each"
	db "<CONT>", "#MON."

	db "<PARA>", "If you don't need"
	db "<LINE>", "it, you should "
	db "<CONT>", "store it via PC."
	db "<DONE>"

;@ path: text/Route15Gate2F
_Route15Gate2FBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "It looks like a"
	db "<LINE>", "small island!"
	db "<DONE>"
;@ path: text/Route16Gate1F
_Route16Gate1FGuardNoPedestriansAllowedText::
	db TX_START, "No pedestrians"
	db "<LINE>", "are allowed on"
	db "<CONT>", "CYCLING ROAD!"
	db "<DONE>"

;@ path: text/Route16Gate1F
_Route16Gate1FGuardCyclingRoadExplanationText::
	db TX_START, "CYCLING ROAD is a"
	db "<LINE>", "downhill course"
	db "<CONT>", "by the sea. It's"
	db "<CONT>", "a great ride."
	db "<DONE>"

;@ path: text/Route16Gate1F
_Route16Gate1FGuardWaitUpText::
	db TX_START, "Excuse me! Wait"
	db "<LINE>", "up please!"
	db "<DONE>"

;@ path: text/Route16Gate1F
_Route16Gate1FGamblerText::
	db TX_START, "How'd you get in?"
	db "<LINE>", "Good effort!"
	db "<DONE>"
;@ path: text/Route16Gate2F
_Route16Gate2FLittleBoyText::
	db TX_START, "I'm going for a"
	db "<LINE>", "ride with my girl"
	db "<CONT>", "friend!"
	db "<DONE>"

;@ path: text/Route16Gate2F
_Route16Gate2FLittleGirlText::
	db TX_START, "We're going"
	db "<LINE>", "riding together!"
	db "<DONE>"

;@ path: text/Route16Gate2F
_Route16Gate2FLeftBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "It's CELADON DEPT."
	db "<LINE>", "STORE!"
	db "<DONE>"

;@ path: text/Route16Gate2F
_Route16Gate2FRightBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "There's a long"
	db "<LINE>", "path over water!"
	db "<DONE>"
;@ path: text/Route16FlyHouse
_Route16FlyHouseBrunetteGirlText::
	db TX_START, "Oh, you found my"
	db "<LINE>", "secret retreat!"

	db "<PARA>", "Please don't tell"
	db "<LINE>", "anyone I'm here."
	db "<CONT>", "I'll make it up"
	db "<CONT>", "to you with this!"
	db "<PROMPT>"

;@ path: text/Route16FlyHouse
_Route16FlyHouseBrunetteGirlReceivedHM02Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "HM02!@"
	db TX_END

;@ path: text/Route16FlyHouse
_Route16FlyHouseBrunetteGirlHM02ExplanationText::
	db TX_START, "HM02 is FLY."
	db "<LINE>", "It will take you"
	db "<CONT>", "back to any town."

	db "<PARA>", "Put it to good"
	db "<LINE>", "use!"
	db "<DONE>"

;@ path: text/Route16FlyHouse
_Route16FlyHouseBrunetteGirlHM02NoRoomText::
	db TX_START, "You don't have any"
	db "<LINE>", "room for this."
	db "<DONE>"

;@ path: text/Route16FlyHouse
_Route16FlyHouseFearowText::
	db TX_START, "FEAROW: Kyueen!"
	db "<DONE>"
;@ path: text/Route18Gate1F
_Route18Gate1FGuardYouNeedABicycleText::
	db TX_START, "You need a BICYCLE"
	db "<LINE>", "for CYCLING ROAD!"
	db "<DONE>"

;@ path: text/Route18Gate1F
_Route18Gate1FGuardCyclingRoadUphillText::
	db TX_START, "CYCLING ROAD is"
	db "<LINE>", "all uphill from"
	db "<CONT>", "here."
	db "<DONE>"

;@ path: text/Route18Gate1F
_Route18Gate1FGuardExcuseMeText::
	db TX_START, "Excuse me!"
	db "<DONE>"
;@ path: text/Route18Gate2F
_Route18Gate2FLeftBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "PALLET TOWN is in"
	db "<LINE>", "the west!"
	db "<DONE>"

;@ path: text/Route18Gate2F
_Route18Gate2FRightBinocularsText::
	db TX_START, "Looked into the"
	db "<LINE>", "binoculars."

	db "<PARA>", "There are people"
	db "<LINE>", "swimming!"
	db "<DONE>"
;@ path: text/Route22Gate
_Route22GateGuardNoBoulderbadgeText::
	db TX_START, "Only truly skilled"
	db "<LINE>", "trainers are"
	db "<CONT>", "allowed through."

	db "<PARA>", "You don't have the"
	db "<LINE>", "BOULDERBADGE yet!@"
	db TX_END

;@ path: text/Route22Gate
_Route22GateGuardICantLetYouPassText::
	db TX_START

	db "<PARA>", "The rules are"
	db "<LINE>", "rules. I can't"
	db "<CONT>", "let you pass."
	db "<DONE>"

;@ path: text/Route22Gate
_Route22GateGuardGoRightAheadText::
	db TX_START, "Oh! That is the"
	db "<LINE>", "BOULDERBADGE!"
	db "<CONT>", "Go right ahead!@"
	db TX_END
;@ path: text/VictoryRoad2F
_VictoryRoad2FMoltresBattleText::
	db TX_START, "Gyaoo!@"
	db TX_END

;@ path: text/VictoryRoad2F
_VictoryRoad2FHikerBattleText::
	db TX_START, "VICTORY ROAD is"
	db "<LINE>", "the final test"
	db "<CONT>", "for trainers!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FHikerEndBattleText::
	db TX_START, "Aiyah!"
	db "<PROMPT>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FHikerAfterBattleText::
	db TX_START, "If you get stuck,"
	db "<LINE>", "try moving some"
	db "<CONT>", "boulders around!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd1BattleText::
	db TX_START, "Ah, so you wish"
	db "<LINE>", "to challenge the"
	db "<CONT>", "ELITE FOUR?"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd1EndBattleText::
	db TX_START, "You"
	db "<LINE>", "got me!"
	db "<PROMPT>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd1AfterBattleText::
	db TX_START, "<RIVAL> also came"
	db "<LINE>", "through here!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FCooltrainerMBattleText::
	db TX_START, "Come on!"
	db "<LINE>", "I'll whip you!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FCooltrainerMEndBattleText::
	db TX_START, "I got"
	db "<LINE>", "whipped!"
	db "<PROMPT>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FCooltrainerMAfterBattleText::
	db TX_START, "You earned the"
	db "<LINE>", "right to be on"
	db "<CONT>", "VICTORY ROAD!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd2BattleText::
	db TX_START, "If you can get"
	db "<LINE>", "through here, you"
	db "<CONT>", "can go meet the"
	db "<CONT>", "ELITE FOUR!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd2EndBattleText::
	db TX_START, "No!"
	db "<LINE>", "Unbelievable!"
	db "<PROMPT>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd2AfterBattleText::
	db TX_START, "I can beat you"
	db "<LINE>", "when it comes to"
	db "<CONT>", "knowledge about"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd3BattleText::
	db TX_START, "Is VICTORY ROAD"
	db "<LINE>", "too tough?"
	db "<DONE>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd3EndBattleText::
	db TX_START, "Well"
	db "<LINE>", "done!"
	db "<PROMPT>"

;@ path: text/VictoryRoad2F
_VictoryRoad2FSuperNerd3AfterBattleText::
	db TX_START, "Many trainers give"
	db "<LINE>", "up the challenge"
	db "<CONT>", "here."
	db "<DONE>"
;@ path: text/BillsHouse
_BillsHouseBillImNotAPokemonText::
	db TX_START, "Hiya! I'm a"
	db "<LINE>", "#MON..."
	db "<CONT>", "...No I'm not!"

	db "<PARA>", "Call me BILL!"
	db "<LINE>", "I'm a true blue"
	db "<CONT>", "#MANIAC! Hey!"
	db "<CONT>", "What's with that"
	db "<CONT>", "skeptical look?"

	db "<PARA>", "I'm not joshing"
	db "<LINE>", "you, I screwed up"
	db "<CONT>", "an experiment and"
	db "<CONT>", "got combined with"
	db "<CONT>", "a #MON!"

	db "<PARA>", "So, how about it?"
	db "<LINE>", "Help me out here!"
	db "<DONE>"

;@ path: text/BillsHouse
_BillsHouseBillUseSeparationSystemText::
	db TX_START, "When I'm in the"
	db "<LINE>", "TELEPORTER, go to"
	db "<CONT>", "my PC and run the"
	db "<CONT>", "Cell Separation"
	db "<CONT>", "System!"
	db "<DONE>"

;@ path: text/BillsHouse
_BillsHouseBillNoYouGottaHelpText::
	db TX_START, "No!? Come on, you"
	db "<LINE>", "gotta help a guy"
	db "<CONT>", "in deep trouble!"

	db "<PARA>", "What do you say,"
	db "<LINE>", "chief? Please?"
	db "<CONT>", "OK? All right!"
	db "<PROMPT>"

;@ path: text/BillsHouse
_BillsHouseBillThankYouText::
	db TX_START, "BILL: Yeehah!"
	db "<LINE>", "Thanks, bud! I"
	db "<CONT>", "owe you one!"

	db "<PARA>", "So, did you come"
	db "<LINE>", "to see my #MON"
	db "<CONT>", "collection?"
	db "<CONT>", "You didn't?"
	db "<CONT>", "That's a bummer."

	db "<PARA>", "I've got to thank"
	db "<LINE>", "you... Oh here,"
	db "<CONT>", "maybe this'll do."
	db "<PROMPT>"

;@ path: text/BillsHouse
_SSTicketReceivedText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "an @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/BillsHouse
_SSTicketNoRoomText::
	db TX_START, "You've got too"
	db "<LINE>", "much stuff, bud!"
	db "<DONE>"

;@ path: text/BillsHouse
_BillsHouseBillWhyDontYouGoInsteadOfMeText::
	db TX_START, "That cruise ship,"
	db "<LINE>", "S.S.ANNE, is in"
	db "<CONT>", "VERMILION CITY."
	db "<CONT>", "Its passengers"
	db "<CONT>", "are all trainers!"

	db "<PARA>", "They invited me"
	db "<LINE>", "to their party,"
	db "<CONT>", "but I can't stand"
	db "<CONT>", "fancy do's. Why"
	db "<CONT>", "don't you go"
	db "<CONT>", "instead of me?"
	db "<DONE>"

;@ path: text/BillsHouse
_BillsHouseBillCheckOutMyRarePokemonText::
	db TX_START, "BILL: Look, bud,"
	db "<LINE>", "just check out"
	db "<CONT>", "some of my rare"
	db "<CONT>", "#MON on my PC!"
	db "<DONE>"
;@ path: text/Route1
_Route1Youngster1MartSampleText::
	db TX_START, "Hi! I work at a"
	db "<LINE>", "#MON MART."

	db "<PARA>", "It's a convenient"
	db "<LINE>", "shop, so please"
	db "<CONT>", "visit us in"
	db "<CONT>", "VIRIDIAN CITY."

	db "<PARA>", "I know, I'll give"
	db "<LINE>", "you a sample!"
	db "<CONT>", "Here you go!"
	db "<PROMPT>"

;@ path: text/Route1
_Route1Youngster1GotPotionText::
	db TX_START, "<PLAYER> got"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/Route1
_Route1Youngster1AlsoGotPokeballsText::
	db TX_START, "We also carry"
	db "<LINE>", "# BALLs for"
	db "<CONT>", "catching #MON!"
	db "<DONE>"

;@ path: text/Route1
_Route1Youngster1NoRoomText::
	db TX_START, "You have too much"
	db "<LINE>", "stuff with you!"
	db "<DONE>"

;@ path: text/Route1
_Route1Youngster2Text::
	db TX_START, "See those ledges"
	db "<LINE>", "along the road?"

	db "<PARA>", "It's a bit scary,"
	db "<LINE>", "but you can jump"
	db "<CONT>", "from them."

	db "<PARA>", "You can get back"
	db "<LINE>", "to PALLET TOWN"
	db "<CONT>", "quicker that way."
	db "<DONE>"

;@ path: text/Route1
_Route1SignText::
	db TX_START, "ROUTE 1"
	db "<LINE>", "PALLET TOWN -"
	db "<CONT>", "VIRIDIAN CITY"
	db "<DONE>"
;@ path: text/Route2
_Route2SignText::
	db TX_START, "ROUTE 2"
	db "<LINE>", "VIRIDIAN CITY -"
	db "<CONT>", "PEWTER CITY"
	db "<DONE>"

;@ path: text/Route2
_Route2DiglettsCaveSignText::
	db TX_START, "DIGLETT's CAVE"
	db "<DONE>"
;@ path: text/Route3
_Route3Text1::
	db TX_START, "Whew... I better"
	db "<LINE>", "take a rest..."
	db "<CONT>", "Groan..."

	db "<PARA>", "That tunnel from"
	db "<LINE>", "CERULEAN takes a"
	db "<CONT>", "lot out of you!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster1BattleText::
	db TX_START, "Hey! I met you in"
	db "<LINE>", "VIRIDIAN FOREST!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster1EndBattleText::
	db TX_START, "You"
	db "<LINE>", "beat me again!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3Youngster1AfterBattleText::
	db TX_START, "There are other"
	db "<LINE>", "kinds of #MON"
	db "<CONT>", "than those found"
	db "<CONT>", "in the forest!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster2BattleText::
	db TX_START, "Hi! I like shorts!"
	db "<LINE>", "They're comfy and"
	db "<CONT>", "easy to wear!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster2EndBattleText::
	db TX_START, "I don't"
	db "<LINE>", "believe it!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3Youngster2AfterBattleText::
	db TX_START, "Are you storing"
	db "<LINE>", "your #MON on"
	db "<CONT>", "PC? Each BOX can"
	db "<CONT>", "hold 20 #MON!"
	db "<DONE>"

;@ path: text/Route3
_Route3CooltrainerF1BattleText::
	db TX_START, "You looked at me,"
	db "<LINE>", "didn't you?"
	db "<DONE>"

;@ path: text/Route3
_Route3CooltrainerF1EndBattleText::
	db TX_START, "You're"
	db "<LINE>", "mean!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3CooltrainerF1AfterBattleText::
	db TX_START, "Quit staring if"
	db "<LINE>", "you don't want to"
	db "<CONT>", "fight!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster3BattleText::
	db TX_START, "Are you a trainer?"
	db "<LINE>", "Let's fight!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster3EndBattleText::
	db TX_START, "If I"
	db "<LINE>", "had new #MON I"
	db "<CONT>", "would've won!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3Youngster3AfterBattleText::
	db TX_START, "If a #MON BOX"
	db "<LINE>", "on the PC gets"
	db "<CONT>", "full, just switch"
	db "<CONT>", "to another BOX!"
	db "<DONE>"

;@ path: text/Route3
_Route3CooltrainerF2BattleText::
	db TX_START, "That look you"
	db "<LINE>", "gave me, it's so"
	db "<CONT>", "intriguing!"
	db "<DONE>"

;@ path: text/Route3
_Route3CooltrainerF2EndBattleText::
	db TX_START, "Be nice!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3CooltrainerF2AfterBattleText::
	db TX_START, "Avoid fights by"
	db "<LINE>", "not letting"
	db "<CONT>", "people see you!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster4BattleText::
	db TX_START, "Hey! You're not"
	db "<LINE>", "wearing shorts!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster4EndBattleText::
	db TX_START, "Lost!"
	db "<LINE>", "Lost! Lost!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3Youngster4AfterBattleText::
	db TX_START, "I always wear"
	db "<LINE>", "shorts, even in"
	db "<CONT>", "winter!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster5BattleText::
	db TX_START, "You can fight my"
	db "<LINE>", "new #MON!"
	db "<DONE>"

;@ path: text/Route3
_Route3Youngster5EndBattleText::
	db TX_START, "Done"
	db "<LINE>", "like dinner!"
	db "<PROMPT>"

;@ path: text/Route3
_Route3Youngster5AfterBattleText::
	db TX_START, "Trained #MON"
	db "<LINE>", "are stronger than"
	db "<CONT>", "the wild ones!"
	db "<DONE>"

;@ path: text/Route3
_Route3CooltrainerF3BattleText::
	db TX_START, "Eek! Did you"
	db "<LINE>", "touch me?"
	db "<DONE>"

;@ path: text/Route3
_Route3CooltrainerF3EndBattleText::
	db TX_START, "That's it?"
	db "<PROMPT>"

;@ path: text/Route3
_Route3CooltrainerF3AfterBattleText::
	db TX_START, "ROUTE 4 is at the"
	db "<LINE>", "foot of MT.MOON."
	db "<DONE>"

;@ path: text/Route3
_Route3SignText::
	db TX_START, "ROUTE 3"
	db "<LINE>", "MT.MOON AHEAD"
	db "<DONE>"
;@ path: text/Route4
_Route4CooltrainerF1Text::
	db TX_START, "Ouch! I tripped"
	db "<LINE>", "over a rocky"
	db "<CONT>", "#MON, GEODUDE!"
	db "<DONE>"

;@ path: text/Route4
_Route4CooltrainerF2BattleText::
	db TX_START, "I came to get my"
	db "<LINE>", "mushroom #MON!"
	db "<DONE>"

;@ path: text/Route4
_Route4CooltrainerF2EndBattleText::
	db TX_START, "Oh! My cute"
	db "<LINE>", "mushroom #MON!"
	db "<PROMPT>"

;@ path: text/Route4
_Route4CooltrainerF2AfterBattleText::
	db TX_START, "There might not"
	db "<LINE>", "be any more"
	db "<CONT>", "mushrooms here."

	db "<PARA>", "I think I got"
	db "<LINE>", "them all."
	db "<DONE>"

;@ path: text/Route4
_Route4MtMoonSignText::
	db TX_START, "MT.MOON"
	db "<LINE>", "Tunnel Entrance"
	db "<DONE>"

;@ path: text/Route4
_Route4SignText::
	db TX_START, "ROUTE 4"
	db "<LINE>", "MT.MOON -"
	db "<CONT>", "CERULEAN CITY"
	db "<DONE>"
;@ path: text/Route5
_Route5UndergroundPathSignText::
	db TX_START, "UNDERGROUND PATH"
	db "<LINE>", "CERULEAN CITY -"
	db "<CONT>", "VERMILION CITY"
	db "<DONE>"
;@ path: text/Route6
_Route6CooltrainerM1BattleText::
	db TX_START, "Who's there?"
	db "<LINE>", "Quit listening in"
	db "<CONT>", "on us!"
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerM1EndBattleText::
	db TX_START, "I"
	db "<LINE>", "just can't win!"
	db "<PROMPT>"

;@ path: text/Route6
_Route6CooltrainerAfterBattleText::
	db TX_START, "Whisper..."
	db "<LINE>", "whisper..."
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerF1BattleText::
	db TX_START, "Excuse me! This"
	db "<LINE>", "is a private"
	db "<CONT>", "conversation!"
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerF1EndBattleText::
	db TX_START, "Ugh!"
	db "<LINE>", "I hate losing!"
	db "<PROMPT>"

;@ path: text/Route6
_Route6Youngster1BattleText::
	db TX_START, "There aren't many"
	db "<LINE>", "bugs out here."
	db "<DONE>"

;@ path: text/Route6
_Route6Youngster1EndBattleText::
	db TX_START, "No!"
	db "<LINE>", "You're kidding!"
	db "<PROMPT>"

;@ path: text/Route6
_Route6Youngster1AfterBattleText::
	db TX_START, "I like bugs, so"
	db "<LINE>", "I'm going back to"
	db "<CONT>", "VIRIDIAN FOREST."
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerM2BattleText::
	db TX_START, "Huh? You want"
	db "<LINE>", "to talk to me?"
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerM2EndBattleText::
	db TX_START, "I"
	db "<LINE>", "didn't start it!"
	db "<PROMPT>"

;@ path: text/Route6
_Route6CooltrainerM2AfterBattleText::
	db TX_START, "I should carry"
	db "<LINE>", "more #MON with"
	db "<CONT>", "me for safety."
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerF2BattleText::
	db TX_START, "Me? Well, OK."
	db "<LINE>", "I'll play!"
	db "<DONE>"

;@ path: text/Route6
_Route6CooltrainerF2EndBattleText::
	db TX_START, "Just"
	db "<LINE>", "didn't work!"
	db "<PROMPT>"

;@ path: text/Route6
_Route6CooltrainerF2AfterBattleText::
	db TX_START, "I want to get"
	db "<LINE>", "stronger! What's"
	db "<CONT>", "your secret?"
	db "<DONE>"

;@ path: text/Route6
_Route6Youngster2BattleText::
	db TX_START, "I've never seen"
	db "<LINE>", "you around!"
	db "<CONT>", "Are you good?"
	db "<DONE>"

;@ path: text/Route6
_Route6Youngster2EndBattleText::
	db TX_START, "You"
	db "<LINE>", "are too good!"
	db "<PROMPT>"

;@ path: text/Route6
_Route6Youngster2AfterBattleText::
	db TX_START, "Are my #MON"
	db "<LINE>", "weak? Or, am I"
	db "<CONT>", "just bad?"
	db "<DONE>"

;@ path: text/Route6
_Route6UndergroundPathSignText::
	db TX_START, "UNDERGROUND PATH"
	db "<LINE>", "CERULEAN CITY -"
	db "<CONT>", "VERMILION CITY"
	db "<DONE>"
;@ path: text/Route7
_Route7UndergroundPathSignText::
	db TX_START, "UNDERGROUND PATH"
	db "<LINE>", "CELADON CITY -"
	db "<CONT>", "LAVENDER TOWN"
	db "<DONE>"
;@ path: text/Route8
_Route8SuperNerd1BattleText::
	db TX_START, "You look good at"
	db "<LINE>", "#MON, but"
	db "<CONT>", "how's your chem?"
	db "<DONE>"

;@ path: text/Route8
_Route8SuperNerd1EndBattleText::
	db TX_START, "Ow!"
	db "<LINE>", "Meltdown!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8SuperNerd1AfterBattleText::
	db TX_START, "I am better at"
	db "<LINE>", "school than this!"
	db "<DONE>"

;@ path: text/Route8
_Route8Gambler1BattleText::
	db TX_START, "All right! Let's"
	db "<LINE>", "roll the dice!"
	db "<DONE>"

;@ path: text/Route8
_Route8Gambler1EndBattleText::
	db TX_START, "Drat!"
	db "<LINE>", "Came up short!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8Gambler1AfterBattleText::
	db TX_START, "Lady Luck's not"
	db "<LINE>", "with me today!"
	db "<DONE>"

;@ path: text/Route8
_Route8SuperNerd2BattleText::
	db TX_START, "You need strategy"
	db "<LINE>", "to win at this!"
	db "<DONE>"

;@ path: text/Route8
_Route8SuperNerd2EndBattleText::
	db TX_START, "It's"
	db "<LINE>", "not logical!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8SuperNerd2AfterBattleText::
	db TX_START, "Go with GRIMER"
	db "<LINE>", "first...and..."
	db "<CONT>", "...and...then..."
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF1BattleText::
	db TX_START, "I like NIDORAN, so"
	db "<LINE>", "I collect them!"
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF1EndBattleText::
	db TX_START, "Why? Why??"
	db "<PROMPT>"

;@ path: text/Route8
_Route8CooltrainerF1AfterBattleText::
	db TX_START, "When #MON grow"
	db "<LINE>", "up they get ugly!"
	db "<CONT>", "They shouldn't"
	db "<CONT>", "evolve!"
	db "<DONE>"

;@ path: text/Route8
_Route8SuperNerd3BattleText::
	db TX_START, "School is fun, but"
	db "<LINE>", "so are #MON."
	db "<DONE>"

;@ path: text/Route8
_Route8SuperNerd3EndBattleText::
	db TX_START, "I'll"
	db "<LINE>", "stay with school."
	db "<PROMPT>"

;@ path: text/Route8
_Route8SuperNerd3AfterBattleText::
	db TX_START, "We're stuck here"
	db "<LINE>", "because of the"
	db "<CONT>", "gates at SAFFRON."
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF2BattleText::
	db TX_START, "MEOWTH is so cute,"
	db "<LINE>", "meow, meow, meow!"
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF2EndBattleText::
	db TX_START, "Meow!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8CooltrainerF2AfterBattleText::
	db TX_START, "I think PIDGEY"
	db "<LINE>", "and RATTATA"
	db "<CONT>", "are cute too!"
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF3BattleText::
	db TX_START, "We must look"
	db "<LINE>", "silly standing"
	db "<CONT>", "here like this!"
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF3EndBattleText::
	db TX_START, "Look what"
	db "<LINE>", "you did!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8CooltrainerF3AfterBattleText::
	db TX_START, "SAFFRON's gate"
	db "<LINE>", "keeper won't let"
	db "<CONT>", "us through."
	db "<CONT>", "He's so mean!"
	db "<DONE>"

;@ path: text/Route8
_Route8Gambler2BattleText::
	db TX_START, "I'm a rambling,"
	db "<LINE>", "gambling dude!"
	db "<DONE>"

;@ path: text/Route8
_Route8Gambler2EndBattleText::
	db TX_START, "Missed"
	db "<LINE>", "the big score!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8Gambler2AfterBattleText::
	db TX_START, "Gambling and"
	db "<LINE>", "#MON are like"
	db "<CONT>", "eating peanuts!"
	db "<CONT>", "Just can't stop!"
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF4BattleText::
	db TX_START, "What's a cute,"
	db "<LINE>", "round and fluffy"
	db "<CONT>", "#MON?"
	db "<DONE>"

;@ path: text/Route8
_Route8CooltrainerF4EndBattleText::
	db TX_START, "Stop!"

	db "<PARA>", "Don't be so mean"
	db "<LINE>", "to my CLEFAIRY!"
	db "<PROMPT>"

;@ path: text/Route8
_Route8CooltrainerF4AfterBattleText::
	db TX_START, "I heard that"
	db "<LINE>", "CLEFAIRY evolves"
	db "<CONT>", "when it's exposed"
	db "<CONT>", "to a MOON STONE."
	db "<DONE>"

;@ path: text/Route8
_Route8UndergroundSignText::
	db TX_START, "UNDERGROUND PATH"
	db "<LINE>", "CELADON CITY -"
	db "<CONT>", "LAVENDER TOWN"
	db "<DONE>"
;@ path: text/Route9
_Route9CooltrainerF1BattleText::
	db TX_START, "You have #MON"
	db "<LINE>", "with you!"
	db "<CONT>", "You're mine!"
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerF1EndBattleText::
	db TX_START, "You"
	db "<LINE>", "deceived me!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9CooltrainerF1AfterBattleText::
	db TX_START, "You need light to"
	db "<LINE>", "get through that"
	db "<CONT>", "dark tunnel ahead."
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerM1BattleText::
	db TX_START, "Who's that walking"
	db "<LINE>", "with those good"
	db "<CONT>", "looking #MON?"
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerM1EndBattleText::
	db TX_START, "Out"
	db "<LINE>", "like a light!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9CooltrainerM1AfterBattleText::
	db TX_START, "Keep walking!"
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerM2BattleText::
	db TX_START, "I'm taking ROCK"
	db "<LINE>", "TUNNEL to go to"
	db "<CONT>", "LAVENDER..."
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerM2EndBattleText::
	db TX_START, "Can't"
	db "<LINE>", "measure up!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9CooltrainerM2AfterBattleText::
	db TX_START, "Are you off to"
	db "<LINE>", "ROCK TUNNEL too?"
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerF2BattleText::
	db TX_START, "Don't you dare"
	db "<LINE>", "condescend me!"
	db "<DONE>"

;@ path: text/Route9
_Route9CooltrainerF2EndBattleText::
	db TX_START, "No!"
	db "<LINE>", "You're too much!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9CooltrainerF2AfterBattleText::
	db TX_START, "You're obviously"
	db "<LINE>", "talented! Good"
	db "<CONT>", "luck to you!"
	db "<DONE>"

;@ path: text/Route9
_Route9Hiker1BattleText::
	db TX_START, "Bwahaha!"
	db "<LINE>", "Great! I was"
	db "<CONT>", "bored, eh!"
	db "<DONE>"

;@ path: text/Route9
_Route9Hiker1EndBattleText::
	db TX_START, "Keep it"
	db "<LINE>", "coming, eh!"

	db "<PARA>", "Oh wait. I'm out"
	db "<LINE>", "of #MON!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9Hiker1AfterBattleText::
	db TX_START, "You sure had guts"
	db "<LINE>", "standing up to me"
	db "<CONT>", "there, eh?"
	db "<DONE>"

;@ path: text/Route9
_Route9Hiker2BattleText::
	db TX_START, "Hahaha!"
	db "<LINE>", "Aren't you a"
	db "<CONT>", "little toughie!"
	db "<DONE>"

;@ path: text/Route9
_Route9Hiker2EndBattleText::
	db TX_START, "What's"
	db "<LINE>", "that?"
	db "<PROMPT>"

;@ path: text/Route9
_Route9Hiker2AfterBattleText::
	db TX_START, "Hahaha! Kids"
	db "<LINE>", "should be tough!"
	db "<DONE>"

;@ path: text/Route9
_Route9Youngster1BattleText::
	db TX_START, "I got up early"
	db "<LINE>", "every day to"
	db "<CONT>", "raise my #MON"
	db "<CONT>", "from cocoons!"
	db "<DONE>"

;@ path: text/Route9
_Route9Youngster1EndBattleText::
	db TX_START, "WHAT?"

	db "<PARA>", "What a total"
	db "<LINE>", "waste of time!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9Youngster1AfterBattleText::
	db TX_START, "I have to collect"
	db "<LINE>", "more than bugs to"
	db "<CONT>", "get stronger..."
	db "<DONE>"

;@ path: text/Route9
_Route9Hiker3BattleText::
	db TX_START, "Hahahaha!"
	db "<LINE>", "Come on, dude!"
	db "<DONE>"

;@ path: text/Route9
_Route9Hiker3EndBattleText::
	db TX_START, "Hahahaha!"
	db "<LINE>", "You beat me fair!"
	db "<PROMPT>"

;@ path: text/Route9
_Route9Hiker3AfterBattleText::
	db TX_START, "Hahahaha!"
	db "<LINE>", "Us hearty guys"
	db "<CONT>", "always laugh!"
	db "<DONE>"

;@ path: text/Route9
_Route9Youngster2BattleText::
	db TX_START, "Go, my super bug"
	db "<LINE>", "#MON!"
	db "<DONE>"

;@ path: text/Route9
_Route9Youngster2EndBattleText::
	db TX_START, "My"
	db "<LINE>", "bugs..."
	db "<PROMPT>"

;@ path: text/Route9
_Route9Youngster2AfterBattleText::
	db TX_START, "If you don't like"
	db "<LINE>", "bug #MON, you"
	db "<CONT>", "bug me!"
	db "<DONE>"

;@ path: text/Route9
_Route9SignText::
	db TX_START, "ROUTE 9"
	db "<LINE>", "CERULEAN CITY-"
	db "<CONT>", "ROCK TUNNEL"
	db "<DONE>"
;@ path: text/Route10
_Route10SuperNerd1BattleText::
	db TX_START, "Wow, are you a"
	db "<LINE>", "#MANIAC too?"
	db "<CONT>", "Want to see my"
	db "<CONT>", "collection?"
	db "<DONE>"

;@ path: text/Route10
_Route10SuperNerd1EndBattleText::
	db TX_START, "Humph."
	db "<LINE>", "I'm not angry!"
	db "<PROMPT>"

;@ path: text/Route10
_Route10SuperNerd1AfterBattleText::
	db TX_START, "I have more rare"
	db "<LINE>", "#MON at home!"
	db "<DONE>"

;@ path: text/Route10
_Route10Hiker1BattleText::
	db TX_START, "Ha-hahah-ah-ha!"
	db "<DONE>"

;@ path: text/Route10
_Route10Hiker1EndBattleText::
	db TX_START, "Ha-haha!"
	db "<LINE>", "Not laughing!"
	db "<CONT>", "Ha-hay fever!"
	db "<CONT>", "Haha-ha-choo!"
	db "<PROMPT>"

;@ path: text/Route10
_Route10Hiker1AfterBattleText::
	db TX_START, "Haha-ha-choo!"
	db "<LINE>", "Ha-choo!"
	db "<CONT>", "Snort! Snivel!"
	db "<DONE>"

;@ path: text/Route10
_Route10SuperNerd2BattleText::
	db TX_START, "Hi kid, want to"
	db "<LINE>", "see my #MON?"
	db "<DONE>"

;@ path: text/Route10
_Route10SuperNerd2EndBattleText::
	db TX_START, "Oh no!"
	db "<LINE>", "My #MON!"
	db "<PROMPT>"

;@ path: text/Route10
_Route10SuperNerd2AfterBattleText::
	db TX_START, "I don't like you"
	db "<LINE>", "for beating me!"
	db "<DONE>"

;@ path: text/Route10
_Route10CooltrainerF1BattleText::
	db TX_START, "I've been to a"
	db "<LINE>", "#MON GYM a few"
	db "<CONT>", "times. But, I"
	db "<CONT>", "lost each time."
	db "<DONE>"

;@ path: text/Route10
_Route10CooltrainerF1EndBattleText::
	db TX_START, "Ohh!"
	db "<LINE>", "Blew it again!"
	db "<PROMPT>"

;@ path: text/Route10
_Route10CooltrainerF1AfterBattleText::
	db TX_START, "I noticed some"
	db "<LINE>", "#MANIACs"
	db "<CONT>", "prowling around."
	db "<DONE>"

;@ path: text/Route10
_Route10Hiker2BattleText::
	db TX_START, "Ah! This mountain"
	db "<LINE>", "air is delicious!"
	db "<DONE>"

;@ path: text/Route10
_Route10Hiker2EndBattleText::
	db TX_START, "That"
	db "<LINE>", "cleared my head!"
	db "<PROMPT>"

;@ path: text/Route10
_Route10Hiker2AfterBattleText::
	db TX_START, "I feel bloated on"
	db "<LINE>", "mountain air!"
	db "<DONE>"

;@ path: text/Route10
_Route10CooltrainerF2BattleText::
	db TX_START, "I'm feeling a bit"
	db "<LINE>", "faint from this"
	db "<CONT>", "tough hike."
	db "<DONE>"

;@ path: text/Route10
_Route10CooltrainerF2EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "not up to it!"
	db "<PROMPT>"

;@ path: text/Route10
_Route10CooltrainerF2AfterBattleText::
	db TX_START, "The #MON here"
	db "<LINE>", "are so chunky!"
	db "<CONT>", "There should be a"
	db "<CONT>", "pink one with a"
	db "<CONT>", "floral pattern!"
	db "<DONE>"

;@ path: text/Route10
_Route10RockTunnelSignText::
	db TX_START, "ROCK TUNNEL"
	db "<DONE>"

;@ path: text/Route10
_Route10PowerPlantSignText::
	db TX_START, "POWER PLANT"
	db "<DONE>"
;@ path: text/Route11
_Route11Gambler1BattleText::
	db TX_START, "Win, lose or draw!"
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler1EndBattleText::
	db TX_START, "Atcha!"
	db "<LINE>", "Didn't go my way!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11Gambler1AfterBattleText::
	db TX_START, "#MON is life!"
	db "<LINE>", "And to live is to"
	db "<CONT>", "gamble!"
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler2BattleText::
	db TX_START, "Competition! I"
	db "<LINE>", "can't get enough!"
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler2EndBattleText::
	db TX_START, "I had"
	db "<LINE>", "a chance!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11Gambler2AfterBattleText::
	db TX_START, "You can't be a"
	db "<LINE>", "coward in the"
	db "<CONT>", "world of #MON!"
	db "<DONE>"

;@ path: text/Route11
_Route11Youngster1BattleText::
	db TX_START, "Let's go, but"
	db "<LINE>", "don't cheat!"
	db "<DONE>"

;@ path: text/Route11
_Route11Youngster1EndBattleText::
	db TX_START, "Huh?"
	db "<LINE>", "That's not right!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11Youngster1AfterBattleText::
	db TX_START, "I did my best! I"
	db "<LINE>", "have no regrets!"
	db "<DONE>"

;@ path: text/Route11
_Route11SuperNerd1BattleText::
	db TX_START, "Careful!"
	db "<LINE>", "I'm laying down"
	db "<CONT>", "some cables!"
	db "<DONE>"

;@ path: text/Route11
_Route11SuperNerd1EndBattleText::
	db TX_START, "That"
	db "<LINE>", "was electric!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11SuperNerd1AfterBattleText::
	db TX_START, "Spread the word"
	db "<LINE>", "to save energy!"
	db "<DONE>"

;@ path: text/Route11
_Route11Youngster2BattleText::
	db TX_START, "I just became a"
	db "<LINE>", "trainer! But, I"
	db "<CONT>", "think I can win!"
	db "<DONE>"

;@ path: text/Route11
_Route11Youngster2EndBattleText::
	db TX_START, "My"
	db "<LINE>", "#MON couldn't!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11Youngster2AfterBattleText5::
	db TX_START, "What do you want?"
	db "<LINE>", "Leave me alone!"
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler3BattleText::
	db TX_START, "Fwahaha! I have"
	db "<LINE>", "never lost!"
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler3EndBattleText::
	db TX_START, "My"
	db "<LINE>", "first loss!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11Gambler3AfterBattleText::
	db TX_START, "Luck of the draw!"
	db "<LINE>", "Just luck!"
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler4BattleText::
	db TX_START, "I have never won"
	db "<LINE>", "before..."
	db "<DONE>"

;@ path: text/Route11
_Route11Gambler4EndBattleText::
	db TX_START, "I saw"
	db "<LINE>", "this coming..."
	db "<PROMPT>"

;@ path: text/Route11
_Route11Gambler4AfterBattleText::
	db TX_START, "It's just luck."
	db "<LINE>", "Luck of the draw."
	db "<DONE>"

;@ path: text/Route11
_Route11Youngster3BattleText::
	db TX_START, "I'm the best in"
	db "<LINE>", "my class!"
	db "<DONE>"

;@ path: text/Route11
_Route11Youngster3EndBattleText::
	db TX_START, "Darn!"
	db "<LINE>", "I need to make my"
	db "<CONT>", "#MON stronger!"
	db "<PROMPT>"

;@ path: text/Route11
_Route11Youngster3AfterBattleText::
	db TX_START, "There's a fat"
	db "<LINE>", "#MON that"
	db "<CONT>", "comes down from"
	db "<CONT>", "the mountains."

	db "<PARA>", "It's strong if"
	db "<LINE>", "you can get it."
	db "<DONE>"

;@ path: text/Route11
_Route11SuperNerd2BattleText::
	db TX_START, "Watch out for"
	db "<LINE>", "live wires!"
	db "<DONE>"


SECTION "Text 5", ROMX

;@ path: text/Route11_2
_Route11SuperNerd2EndBattleText::
	db TX_START, "Whoa!"
	db "<LINE>", "You spark plug!"
	db "<PROMPT>"

;@ path: text/Route11_2
_Route11SuperNerd2AfterBattleText::
	db TX_START, "Well, better get"
	db "<LINE>", "back to work."
	db "<DONE>"

;@ path: text/Route11_2
_Route11Youngster4BattleText::
	db TX_START, "My #MON should"
	db "<LINE>", "be ready by now!"
	db "<DONE>"

;@ path: text/Route11_2
_Route11Youngster4EndBattleText::
	db TX_START, "Too"
	db "<LINE>", "much, too young!"
	db "<PROMPT>"

;@ path: text/Route11_2
_Route11Youngster4AfterBattleText::
	db TX_START, "I better go find"
	db "<LINE>", "stronger ones!"
	db "<DONE>"

;@ path: text/Route11_2
_Route11DiglettsCaveSignText::
	db TX_START, "DIGLETT's CAVE"
	db "<DONE>"
;@ path: text/Route12
_Route12SnorlaxText::
	db TX_START, "A sleeping #MON"
	db "<LINE>", "blocks the way!"
	db "<DONE>"

;@ path: text/Route12
_Route12SnorlaxWokeUpText::
	db TX_START, "SNORLAX woke up!"

	db "<PARA>", "It attacked in a"
	db "<LINE>", "grumpy rage!"
	db "<DONE>"

;@ path: text/Route12
_Route12SnorlaxCalmedDownText::
	db TX_START, "SNORLAX calmed"
	db "<LINE>", "down! With a big"
	db "<CONT>", "yawn, it returned"
	db "<CONT>", "to the mountains!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher1BattleText::
	db TX_START, "Yeah! I got a"
	db "<LINE>", "bite, here!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher1EndBattleText::
	db TX_START, "Tch!"
	db "<LINE>", "Just a small fry!"
	db "<PROMPT>"

;@ path: text/Route12
_Route12Fisher1AfterBattleText::
	db TX_START, "Hang on! My line's"
	db "<LINE>", "snagged!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher2BattleText::
	db TX_START, "Be patient!"
	db "<LINE>", "Fishing is a"
	db "<CONT>", "waiting game!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher2EndBattleText::
	db TX_START, "That"
	db "<LINE>", "one got away!"
	db "<PROMPT>"

;@ path: text/Route12
_Route12Fisher2AfterBattleText::
	db TX_START, "With a better ROD,"
	db "<LINE>", "I could catch"
	db "<CONT>", "better #MON!"
	db "<DONE>"

;@ path: text/Route12
_Route12CooltrainerMBattleText::
	db TX_START, "Have you found a"
	db "<LINE>", "MOON STONE?"
	db "<DONE>"

;@ path: text/Route12
_Route12CooltrainerMEndBattleText::
	db TX_START, "Oww!"
	db "<PROMPT>"

;@ path: text/Route12
_Route12CooltrainerMAfterBattleText::
	db TX_START, "I could have made"
	db "<LINE>", "my #MON evolve"
	db "<CONT>", "with MOON STONE!"
	db "<DONE>"

;@ path: text/Route12
_Route12SuperNerdBattleText::
	db TX_START, "Electricity is my"
	db "<LINE>", "specialty!"
	db "<DONE>"

;@ path: text/Route12
_Route12SuperNerdEndBattleText::
	db TX_START, "Unplugged!"
	db "<PROMPT>"

;@ path: text/Route12
_Route12SuperNerdAfterBattleText::
	db TX_START, "Water conducts"
	db "<LINE>", "electricity, so"
	db "<CONT>", "you should zap"
	db "<CONT>", "sea #MON!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher3BattleText::
	db TX_START, "The FISHING FOOL"
	db "<LINE>", "vs. #MON KID!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher3EndBattleText::
	db TX_START, "Too"
	db "<LINE>", "much!"
	db "<PROMPT>"

;@ path: text/Route12
_Route12Fisher3AfterBattleText::
	db TX_START, "You beat me at"
	db "<LINE>", "#MON, but I'm"
	db "<CONT>", "good at fishing!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher4BattleText::
	db TX_START, "I'd rather be"
	db "<LINE>", "working!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher4EndBattleText::
	db TX_START, "It's"
	db "<LINE>", "not easy..."
	db "<PROMPT>"

;@ path: text/Route12
_Route12Fisher4AfterBattleText::
	db TX_START, "It's all right."
	db "<LINE>", "Losing doesn't"
	db "<CONT>", "bug me any more."
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher5BattleText::
	db TX_START, "You never know"
	db "<LINE>", "what you could"
	db "<CONT>", "catch!"
	db "<DONE>"

;@ path: text/Route12
_Route12Fisher5EndBattleText::
	db TX_START, "Lost"
	db "<LINE>", "it!"
	db "<PROMPT>"

;@ path: text/Route12
_Route12Fisher5AfterBattleText::
	db TX_START, "I catch MAGIKARP"
	db "<LINE>", "all the time, but"
	db "<CONT>", "they're so weak!"
	db "<DONE>"

;@ path: text/Route12
_Route12SignText::
	db TX_START, "ROUTE 12 "
	db "<LINE>", "North to LAVENDER"
	db "<DONE>"

;@ path: text/Route12
_Route12SportFishingSignText::
	db TX_START, "SPORT FISHING AREA"
	db "<DONE>"
;@ path: text/Route13
_Route13CooltrainerM1BattleText::
	db TX_START, "My bird #MON"
	db "<LINE>", "want to scrap!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerM1EndBattleText::
	db TX_START, "My"
	db "<LINE>", "bird combo lost?"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerM1AfterBattleText::
	db TX_START, "My #MON look"
	db "<LINE>", "happy even though"
	db "<CONT>", "they lost."
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF1BattleText::
	db TX_START, "I'm told I'm good"
	db "<LINE>", "for a kid!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF1EndBattleText::
	db TX_START, "Ohh!"
	db "<LINE>", "I lost!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerF1AfterBattleText::
	db TX_START, "I want to become"
	db "<LINE>", "a good trainer."
	db "<CONT>", "I'll train hard."
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF2BattleText::
	db TX_START, "Wow! Your BADGEs"
	db "<LINE>", "are too cool!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF2EndBattleText::
	db TX_START, "Not"
	db "<LINE>", "enough!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerF2AfterBattleText::
	db TX_START, "You got those"
	db "<LINE>", "BADGEs from GYM"
	db "<CONT>", "LEADERs. I know!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF3BattleText::
	db TX_START, "My cute #MON"
	db "<LINE>", "wish to make your"
	db "<CONT>", "acquaintance."
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF3EndBattleText::
	db TX_START, "Wow!"
	db "<LINE>", "You totally won!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerF3AfterBattleText::
	db TX_START, "You have to make"
	db "<LINE>", "#MON fight to"
	db "<CONT>", "toughen them up!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF4BattleText::
	db TX_START, "I found CARBOS in"
	db "<LINE>", "a cave once."
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerF4EndBattleText::
	db TX_START, "Just"
	db "<LINE>", "messed up!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerF4AfterBattleText::
	db TX_START, "CARBOS boosted"
	db "<LINE>", "the SPEED of my"
	db "<CONT>", "#MON."
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerM2BattleText::
	db TX_START, "The wind's blowing"
	db "<LINE>", "my way!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerM2EndBattleText::
	db TX_START, "The"
	db "<LINE>", "wind turned!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerM2AfterBattleText::
	db TX_START, "I'm beat. I guess"
	db "<LINE>", "I'll FLY home."
	db "<DONE>"

;@ path: text/Route13
_Route13Beauty1BattleText::
	db TX_START, "Sure, I'll play"
	db "<LINE>", "with you!"
	db "<DONE>"

;@ path: text/Route13
_Route13Beauty1EndBattleText::
	db TX_START, "Oh!"
	db "<LINE>", "You little brute!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13Beauty1AfterBattleText::
	db TX_START, "I wonder which is"
	db "<LINE>", "stronger, male or"
	db "<CONT>", "female #MON?"
	db "<DONE>"

;@ path: text/Route13
_Route13Beauty2BattleText::
	db TX_START, "Do you want to"
	db "<LINE>", "#MON with me?"
	db "<DONE>"

;@ path: text/Route13
_Route13Beauty2EndBattleText::
	db TX_START, "It's over"
	db "<LINE>", "already?"
	db "<PROMPT>"

;@ path: text/Route13
_Route13Beauty2AfterBattleText::
	db TX_START, "I don't know"
	db "<LINE>", "anything about"
	db "<CONT>", "#MON. I just"
	db "<CONT>", "like cool ones!"
	db "<DONE>"

;@ path: text/Route13
_Route13BikerBattleText::
	db TX_START, "What're you"
	db "<LINE>", "lookin' at?"
	db "<DONE>"

;@ path: text/Route13
_Route13BikerEndBattleText::
	db TX_START, "Dang!"
	db "<LINE>", "Stripped gears!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13BikerAfterBattleText::
	db TX_START, "Get lost!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerM3BattleText::
	db TX_START, "I always go with"
	db "<LINE>", "bird #MON!"
	db "<DONE>"

;@ path: text/Route13
_Route13CooltrainerM3EndBattleText::
	db TX_START, "Out"
	db "<LINE>", "of power!"
	db "<PROMPT>"

;@ path: text/Route13
_Route13CooltrainerM3AfterBattleText::
	db TX_START, "I wish I could"
	db "<LINE>", "fly like PIDGEY"
	db "<CONT>", "and PIDGEOTTO..."
	db "<DONE>"

;@ path: text/Route13
_Route13TrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Look to the left"
	db "<LINE>", "of that post!"
	db "<DONE>"

;@ path: text/Route13
_Route13TrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Use SELECT to"
	db "<LINE>", "switch items in"
	db "<CONT>", "the ITEM window!"
	db "<DONE>"

;@ path: text/Route13
_Route13SignText::
	db TX_START, "ROUTE 13"
	db "<LINE>", "North to SILENCE"
	db "<CONT>", "BRIDGE"
	db "<DONE>"
;@ path: text/Route14
_Route14CooltrainerM1BattleText::
	db TX_START, "You need to use"
	db "<LINE>", "TMs to teach good"
	db "<CONT>", "moves to #MON!"
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM1EndBattleText::
	db TX_START, "Not"
	db "<LINE>", "good enough!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14CooltrainerM1AfterBattleText::
	db TX_START, "You have some HMs"
	db "<LINE>", "right? #MON"
	db "<CONT>", "can't ever forget"
	db "<CONT>", "those moves."
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM2BattleText::
	db TX_START, "My bird #MON"
	db "<LINE>", "should be ready"
	db "<CONT>", "for battle."
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM2EndBattleText::
	db TX_START, "Not"
	db "<LINE>", "ready yet!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14CooltrainerM2AfterBattleText::
	db TX_START, "They need to learn"
	db "<LINE>", "better moves."
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM3BattleText::
	db TX_START, "TMs are on sale"
	db "<LINE>", "in CELADON!"
	db "<CONT>", "But, only a few"
	db "<CONT>", "people have HMs!"
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM3EndBattleText::
	db TX_START, "Aww,"
	db "<LINE>", "bummer!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14CooltrainerM3AfterBattleText::
	db TX_START, "Teach #MON"
	db "<LINE>", "moves of the same"
	db "<CONT>", "element type for"
	db "<CONT>", "more power."
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM4BattleText::
	db TX_START, "Have you taught"
	db "<LINE>", "your bird #MON"
	db "<CONT>", "how to FLY?"
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM4EndBattleText::
	db TX_START, "Shot"
	db "<LINE>", "down in flames!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14CooltrainerM4AfterBattleText::
	db TX_START, "Bird #MON are"
	db "<LINE>", "my true love!"
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM5BattleText::
	db TX_START, "Have you heard of"
	db "<LINE>", "the legendary"
	db "<CONT>", "#MON?"
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM5EndBattleText::
	db TX_START, "Why?"
	db "<LINE>", "Why'd I lose?"
	db "<PROMPT>"

;@ path: text/Route14
_Route14CooltrainerM5AfterBattleText::
	db TX_START, "The 3 legendary"
	db "<LINE>", "#MON are all"
	db "<CONT>", "birds of prey."
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM6BattleText::
	db TX_START, "I'm not into it,"
	db "<LINE>", "but OK! Let's go!"
	db "<DONE>"

;@ path: text/Route14
_Route14CooltrainerM6EndBattleText::
	db TX_START, "I"
	db "<LINE>", "knew it!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14CooltrainerM6AfterBattleText::
	db TX_START, "Winning, losing,"
	db "<LINE>", "it doesn't matter"
	db "<CONT>", "in the long run!"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker1BattleText::
	db TX_START, "C'mon, c'mon."
	db "<LINE>", "Let's go, let's"
	db "<CONT>", "go, let's go!"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker1EndBattleText::
	db TX_START, "Arrg!"
	db "<LINE>", "Lost! Get lost!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14Biker1AfterBattleText::
	db TX_START, "What, what, what?"
	db "<LINE>", "What do you want?"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker2BattleText::
	db TX_START, "Perfect! I need to"
	db "<LINE>", "burn some time!"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker2EndBattleText::
	db TX_START, "What?"
	db "<LINE>", "You!?"
	db "<PROMPT>"

;@ path: text/Route14
_Route14Biker2AfterBattleText::
	db TX_START, "Raising #MON"
	db "<LINE>", "is a drag, man."
	db "<DONE>"

;@ path: text/Route14
_Route14Biker3BattleText::
	db TX_START, "We ride out here"
	db "<LINE>", "because there's"
	db "<CONT>", "more room!"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker3EndBattleText::
	db TX_START, "Wipe out!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14Biker3AfterBattleText::
	db TX_START, "It's cool you"
	db "<LINE>", "made your #MON"
	db "<CONT>", "so strong!"

	db "<PARA>", "Might is right!"
	db "<LINE>", "And you know it!"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker4BattleText::
	db TX_START, "#MON fight?"
	db "<LINE>", "Cool! Rumble!"
	db "<DONE>"

;@ path: text/Route14
_Route14Biker4EndBattleText::
	db TX_START, "Blown"
	db "<LINE>", "away!"
	db "<PROMPT>"

;@ path: text/Route14
_Route14Biker4AfterBattleText::
	db TX_START, "You know who'd"
	db "<LINE>", "win, you and me"
	db "<CONT>", "one on one!"
	db "<DONE>"

;@ path: text/Route14
_Route14SignText::
	db TX_START, "ROUTE 14"
	db "<LINE>", "West to FUCHSIA"
	db "<CONT>", "CITY"
	db "<DONE>"
;@ path: text/Route15
_Route15CooltrainerF1BattleText::
	db TX_START, "Let me try out the"
	db "<LINE>", "#MON I just"
	db "<CONT>", "got in a trade!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF1EndBattleText::
	db TX_START, "Not"
	db "<LINE>", "good enough!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15CooltrainerF1AfterBattleText::
	db TX_START, "You can't change"
	db "<LINE>", "the nickname of"
	db "<CONT>", "any #MON you"
	db "<CONT>", "get in a trade."

	db "<PARA>", "Only the Original"
	db "<LINE>", "Trainer can."
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF2BattleText::
	db TX_START, "You look gentle,"
	db "<LINE>", "so I think I can"
	db "<CONT>", "beat you!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF2EndBattleText::
	db TX_START, "No,"
	db "<LINE>", "wrong!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15CooltrainerF2AfterBattleText::
	db TX_START, "I'm afraid of"
	db "<LINE>", "BIKERs, they look"
	db "<CONT>", "so ugly and mean!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerM1BattleText::
	db TX_START, "When I whistle, I"
	db "<LINE>", "can summon bird"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerM1EndBattleText::
	db TX_START, "Ow!"
	db "<LINE>", "That's tragic!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15CooltrainerM1AfterBattleText::
	db TX_START, "Maybe I'm not cut"
	db "<LINE>", "out for battles."
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerM2BattleText::
	db TX_START, "Hmm? My birds are"
	db "<LINE>", "shivering! You're"
	db "<CONT>", "good, aren't you?"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerM2EndBattleText::
	db TX_START, "Just"
	db "<LINE>", "as I thought!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15CooltrainerM2AfterBattleText::
	db TX_START, "Did you know moves"
	db "<LINE>", "like EARTHQUAKE"
	db "<CONT>", "don't have any"
	db "<CONT>", "effect on birds?"
	db "<DONE>"

;@ path: text/Route15
_Route15Beauty1BattleText::
	db TX_START, "Oh, you're a"
	db "<LINE>", "little cutie!"
	db "<DONE>"

;@ path: text/Route15
_Route15Beauty1EndBattleText::
	db TX_START, "You looked"
	db "<LINE>", "so cute too!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15Beauty1AfterBattleText::
	db TX_START, "I forgive you!"
	db "<LINE>", "I can take it!"
	db "<DONE>"

;@ path: text/Route15
_Route15Beauty2BattleText::
	db TX_START, "I raise #MON"
	db "<LINE>", "because I live"
	db "<CONT>", "alone!"
	db "<DONE>"

;@ path: text/Route15
_Route15Beauty2EndBattleText::
	db TX_START, "I didn't"
	db "<LINE>", "ask for this!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15Beauty2AfterBattleText::
	db TX_START, "I just like going"
	db "<LINE>", "home to be with"
	db "<CONT>", "my #MON!"
	db "<DONE>"

;@ path: text/Route15
_Route15Biker1BattleText::
	db TX_START, "Hey kid! C'mon!"
	db "<LINE>", "I just got these!"
	db "<DONE>"

;@ path: text/Route15
_Route15Biker1EndBattleText::
	db TX_START, "Why"
	db "<LINE>", "not?"
	db "<PROMPT>"

;@ path: text/Route15
_Route15Biker1AfterBattleText::
	db TX_START, "You only live"
	db "<LINE>", "once, so I live"
	db "<CONT>", "as an outlaw!"
	db "<CONT>", "TEAM ROCKET RULES!"
	db "<DONE>"

;@ path: text/Route15
_Route15Biker2BattleText::
	db TX_START, "Fork over all your"
	db "<LINE>", "cash when you"
	db "<CONT>", "lose to me, kid!"
	db "<DONE>"

;@ path: text/Route15
_Route15Biker2EndBattleText::
	db TX_START, "That"
	db "<LINE>", "can't be true!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15Biker2AfterBattleText::
	db TX_START, "I was just joking"
	db "<LINE>", "about the money!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF3BattleText::
	db TX_START, "What's cool?"
	db "<LINE>", "Trading #MON!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF3EndBattleText::
	db TX_START, "I"
	db "<LINE>", "said trade!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15CooltrainerF3AfterBattleText::
	db TX_START, "I trade #MON"
	db "<LINE>", "with my friends!"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF4BattleText::
	db TX_START, "Want to play with"
	db "<LINE>", "my #MON?"
	db "<DONE>"

;@ path: text/Route15
_Route15CooltrainerF4EndBattleText::
	db TX_START, "I was"
	db "<LINE>", "too impatient!"
	db "<PROMPT>"

;@ path: text/Route15
_Route15CooltrainerF4AfterBattleText::
	db TX_START, "I'll go train with"
	db "<LINE>", "weaker people.@"
	db TX_END

;@ path: text/Route15
_Route15SignText::
	db TX_START, "ROUTE 15"
	db "<LINE>", "West to FUCHSIA"
	db "<CONT>", "CITY"
	db "<DONE>"
;@ path: text/Route16
_Route16Biker1BattleText::
	db TX_START, "What do you want?"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker1EndBattleText::
	db TX_START, "Don't you"
	db "<LINE>", "dare laugh!"
	db "<PROMPT>"

;@ path: text/Route16
_Route16Biker1AfterBattleText::
	db TX_START, "We like just"
	db "<LINE>", "hanging here,"
	db "<CONT>", "what's it to you?"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker2BattleText::
	db TX_START, "Nice BIKE!"
	db "<LINE>", "Hand it over!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker2EndBattleText::
	db TX_START, "Knock"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: text/Route16
_Route16Biker2AfterBattleText::
	db TX_START, "Forget it, who"
	db "<LINE>", "needs your BIKE!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker3BattleText::
	db TX_START, "Come out and play,"
	db "<LINE>", "little mouse!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker3EndBattleText::
	db TX_START, "You"
	db "<LINE>", "little rat!"
	db "<PROMPT>"

;@ path: text/Route16
_Route16Biker3AfterBattleText::
	db TX_START, "I hate losing!"
	db "<LINE>", "Get away from me!"
	db "<DONE>"

;@ path: text/Route16
_Route16biker4BattleText::
	db TX_START, "Hey, you just"
	db "<LINE>", "bumped me!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker4EndBattleText::
	db TX_START, "Kaboom!"
	db "<PROMPT>"

;@ path: text/Route16
_Route16Biker4AfterBattleText::
	db TX_START, "You can also get"
	db "<LINE>", "to FUCHSIA from"
	db "<CONT>", "VERMILION using a"
	db "<CONT>", "coastal road."
	db "<DONE>"

;@ path: text/Route16
_Route16Biker5BattleText::
	db TX_START, "I'm feeling"
	db "<LINE>", "hungry and mean!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker5EndBattleText::
	db TX_START, "Bad,"
	db "<LINE>", "bad, bad!"
	db "<PROMPT>"

;@ path: text/Route16
_Route16Biker5AfterBattleText::
	db TX_START, "I like my #MON"
	db "<LINE>", "ferocious! They"
	db "<CONT>", "tear up enemies!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker6BattleText::
	db TX_START, "Sure, I'll go!"
	db "<DONE>"

;@ path: text/Route16
_Route16Biker6EndBattleText::
	db TX_START, "Don't make"
	db "<LINE>", "me mad!"
	db "<PROMPT>"

;@ path: text/Route16
_Route16Biker6AfterBattleText::
	db TX_START, "I like harassing"
	db "<LINE>", "people with my"
	db "<CONT>", "vicious #MON!"
	db "<DONE>"

;@ path: text/Route16
_Route16Text7::
	db TX_START, "A sleeping #MON"
	db "<LINE>", "blocks the way!"
	db "<DONE>"

;@ path: text/Route16
_Route16SnorlaxWokeUpText::
	db TX_START, "SNORLAX woke up!"

	db "<PARA>", "It attacked in a"
	db "<LINE>", "grumpy rage!"
	db "<DONE>"

;@ path: text/Route16
_Route16SnorlaxReturnedToMountainsText::
	db TX_START, "With a big yawn,"
	db "<LINE>", "SNORLAX returned"
	db "<CONT>", "to the mountains!"
	db "<DONE>"

;@ path: text/Route16
_Route16CyclingRoadSignText::
	db TX_START, "Enjoy the slope!"
	db "<LINE>", "CYCLING ROAD"
	db "<DONE>"

;@ path: text/Route16
_Route16SignText::
	db TX_START, "ROUTE 16"
	db "<LINE>", "CELADON CITY -"
	db "<CONT>", "FUCHSIA CITY"
	db "<DONE>"
;@ path: text/Route17
_Route17Biker1BattleText::
	db TX_START, "There's no money"
	db "<LINE>", "in fighting kids!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker1EndBattleText::
	db TX_START, "Burned"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker1AfterBattleText::
	db TX_START, "Good stuff is"
	db "<LINE>", "lying around on"
	db "<CONT>", "CYCLING ROAD!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker2BattleText::
	db TX_START, "What do you want,"
	db "<LINE>", "kiddo?"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker2EndBattleText::
	db TX_START, "Whoo!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker2AfterBattleText::
	db TX_START, "I could belly-"
	db "<LINE>", "bump you outta"
	db "<CONT>", "here!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker3BattleText::
	db TX_START, "You heading to"
	db "<LINE>", "FUCHSIA?"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker3EndBattleText::
	db TX_START, "Crash and"
	db "<LINE>", "burn!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker3AfterBattleText::
	db TX_START, "I love racing"
	db "<LINE>", "downhill!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker4BattleText::
	db TX_START, "We're BIKERs!"
	db "<LINE>", "Highway stars!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker4EndBattleText::
	db TX_START, "Smoked!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker4AfterBattleText::
	db TX_START, "Are you looking"
	db "<LINE>", "for adventure?"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker5BattleText::
	db TX_START, "Let VOLTORB"
	db "<LINE>", "electrify you!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker5EndBattleText::
	db TX_START, "Grounded"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker5AfterBattleText::
	db TX_START, "I got my VOLTORB"
	db "<LINE>", "at the abandoned"
	db "<CONT>", "POWER PLANT."
	db "<DONE>"

;@ path: text/Route17
_Route17Biker6BattleText::
	db TX_START, "My #MON won't"
	db "<LINE>", "evolve! Why?"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker6EndBattleText::
	db TX_START, "Why,"
	db "<LINE>", "you!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker6AfterBattleText::
	db TX_START, "Maybe some #MON"
	db "<LINE>", "need element"
	db "<CONT>", "STONEs to evolve."
	db "<DONE>"

;@ path: text/Route17
_Route17Biker7BattleText::
	db TX_START, "I need a little"
	db "<LINE>", "exercise!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker7EndBattleText::
	db TX_START, "Whew!"
	db "<LINE>", "Good workout!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker7AfterBattleText::
	db TX_START, "I'm sure I lost"
	db "<LINE>", "weight there!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker8BattleText::
	db TX_START, "Be a rebel!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker8EndBattleText::
	db TX_START, "Aaaargh!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker8AfterBattleText::
	db TX_START, "Be ready to fight"
	db "<LINE>", "for your beliefs!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker9BattleText::
	db TX_START, "Nice BIKE!"
	db "<LINE>", "How's it handle?"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker9EndBattleText::
	db TX_START, "Shoot!"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker9AfterBattleText::
	db TX_START, "The slope makes"
	db "<LINE>", "it hard to steer!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker10BattleText::
	db TX_START, "Get lost kid!"
	db "<LINE>", "I'm bushed!"
	db "<DONE>"

;@ path: text/Route17
_Route17Biker10EndBattleText::
	db TX_START, "Are you"
	db "<LINE>", "satisfied?"
	db "<PROMPT>"

;@ path: text/Route17
_Route17Biker10AfterBattleText::
	db TX_START, "I need to catch"
	db "<LINE>", "a few Zs!"
	db "<DONE>"

;@ path: text/Route17
_Route17NoticeSign1Text::
	db TX_START, "It's a notice!"

	db "<PARA>", "Watch out for"
	db "<LINE>", "discarded items!"
	db "<DONE>"

;@ path: text/Route17
_Route17TrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "All #MON are"
	db "<LINE>", "unique."

	db "<PARA>", "Even #MON of"
	db "<LINE>", "the same type and"
	db "<CONT>", "level grow at"
	db "<CONT>", "different rates."
	db "<DONE>"

;@ path: text/Route17
_Route17TrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Press the A or B"
	db "<LINE>", "Button to stay in"
	db "<CONT>", "place while on a"
	db "<CONT>", "slope."
	db "<DONE>"

;@ path: text/Route17
_Route17SignText::
	db TX_START, "ROUTE 17"
	db "<LINE>", "CELADON CITY -"
	db "<CONT>", "FUCHSIA CITY"
	db "<DONE>"

;@ path: text/Route17
_Route17NoticeSign2Text::
	db TX_START, "It's a notice!"

	db "<PARA>", "Don't throw the"
	db "<LINE>", "game, throw #"
	db "<CONT>", "BALLs instead!"
	db "<DONE>"

;@ path: text/Route17
_Route17CyclingRoadEndsSignText::
	db TX_START, "CYCLING ROAD"
	db "<LINE>", "Slope ends here!"
	db "<DONE>"
;@ path: text/Route18
_Route18CooltrainerM1BattleText::
	db TX_START, "I always check"
	db "<LINE>", "every grassy area"
	db "<CONT>", "for new #MON."
	db "<DONE>"

;@ path: text/Route18
_Route18CooltrainerM1EndBattleText::
	db TX_START, "Tch!"
	db "<PROMPT>"

;@ path: text/Route18
_Route18CooltrainerM1AfterBattleText::
	db TX_START, "I wish I had a"
	db "<LINE>", "BIKE!"
	db "<DONE>"

;@ path: text/Route18
_Route18CooltrainerM2BattleText::
	db TX_START, "Kurukkoo!"
	db "<LINE>", "How do you like"
	db "<CONT>", "my bird call?"
	db "<DONE>"

;@ path: text/Route18
_Route18CooltrainerM2EndBattleText::
	db TX_START, "I"
	db "<LINE>", "had to bug you!"
	db "<PROMPT>"

;@ path: text/Route18
_Route18CooltrainerM2AfterBattleText::
	db TX_START, "I also collect sea"
	db "<LINE>", "#MON on"
	db "<CONT>", "weekends!"
	db "<DONE>"

;@ path: text/Route18
_Route18CooltrainerM3BattleText::
	db TX_START, "This is my turf!"
	db "<LINE>", "Get out of here!"
	db "<DONE>"

;@ path: text/Route18
_Route18CooltrainerM3EndBattleText::
	db TX_START, "Darn!"
	db "<PROMPT>"

;@ path: text/Route18
_Route18CooltrainerM3AfterBattleText::
	db TX_START, "This is my fave"
	db "<LINE>", "#MON hunting"
	db "<CONT>", "area!"
	db "<DONE>"

;@ path: text/Route18
_Route18SignText::
	db TX_START, "ROUTE 18"
	db "<LINE>", "CELADON CITY -"
	db "<CONT>", "FUCHSIA CITY"
	db "<DONE>"

;@ path: text/Route18
_Route18CyclingRoadSignText::
	db TX_START, "CYCLING ROAD"
	db "<LINE>", "No pedestrians"
	db "<CONT>", "permitted!"
	db "<DONE>"
;@ path: text/Route19
_Route19CooltrainerM1BattleText::
	db TX_START, "Have to warm up"
	db "<LINE>", "before my swim!"
	db "<DONE>"

;@ path: text/Route19
_Route19CooltrainerM1EndBattleText::
	db TX_START, "All"
	db "<LINE>", "warmed up!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19CooltrainerM1AfterBattleText::
	db TX_START, "Thanks, kid! I'm"
	db "<LINE>", "ready for a swim!"
	db "<DONE>"

;@ path: text/Route19
_Route19CooltrainerM2BattleText::
	db TX_START, "Wait! You'll have"
	db "<LINE>", "a heart attack!"
	db "<DONE>"

;@ path: text/Route19
_Route19CooltrainerM2EndBattleText::
	db TX_START, "Ooh!"
	db "<LINE>", "That's chilly!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19CooltrainerM2AfterBattleText::
	db TX_START, "Watch out for"
	db "<LINE>", "TENTACOOL!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer1BattleText::
	db TX_START, "I love swimming!"
	db "<LINE>", "What about you?"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer1EndBattleText::
	db TX_START, "Belly"
	db "<LINE>", "flop!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer1AfterBattleText::
	db TX_START, "I can beat #MON"
	db "<LINE>", "at swimming!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer2BattleText::
	db TX_START, "What's beyond the"
	db "<LINE>", "horizon?"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer2EndBattleText::
	db TX_START, "Glub!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer2AfterBattleText::
	db TX_START, "I see a couple of"
	db "<LINE>", "islands!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer3BattleText::
	db TX_START, "I tried diving"
	db "<LINE>", "for #MON, but"
	db "<CONT>", "it was a no go!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer3EndBattleText::
	db TX_START, "Help!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer3AfterBattleText::
	db TX_START, "You have to fish"
	db "<LINE>", "for sea #MON!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer4BattleText::
	db TX_START, "I look at the"
	db "<LINE>", "sea to forget!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer4EndBattleText::
	db TX_START, "Ooh!"
	db "<LINE>", "Traumatic!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer4AfterBattleText::
	db TX_START, "I'm looking at the"
	db "<LINE>", "sea to forget!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer5BattleText::
	db TX_START, "Oh, I just love"
	db "<LINE>", "your ride! Can I"
	db "<CONT>", "have it if I win?"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer5EndBattleText::
	db TX_START, "Oh!"
	db "<LINE>", "I lost!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer5AfterBattleText::
	db TX_START, "It's still a long"
	db "<LINE>", "way to go to"
	db "<CONT>", "SEAFOAM ISLANDS."
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer6BattleText::
	db TX_START, "Swimming's great!"
	db "<LINE>", "Sunburns aren't!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer6EndBattleText::
	db TX_START, "Shocker!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer6AfterBattleText::
	db TX_START, "My boy friend"
	db "<LINE>", "wanted to swim to"
	db "<CONT>", "SEAFOAM ISLANDS."
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer7BattleText::
	db TX_START, "These waters are"
	db "<LINE>", "treacherous!"
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer7EndBattleText::
	db TX_START, "Ooh!"
	db "<LINE>", "Dangerous!"
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer7AfterBattleText::
	db TX_START, "I got a cramp!"
	db "<LINE>", "Glub, glub..."
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer8BattleText::
	db TX_START, "I swam here, but"
	db "<LINE>", "I'm tired."
	db "<DONE>"

;@ path: text/Route19
_Route19Swimmer8EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "exhausted..."
	db "<PROMPT>"

;@ path: text/Route19
_Route19Swimmer8AfterBattleText::
	db TX_START, "LAPRAS is so big,"
	db "<LINE>", "it must keep you"
	db "<CONT>", "dry on water."
	db "<DONE>"

;@ path: text/Route19
_Route19SignText::
	db TX_START, "SEA ROUTE 19"
	db "<LINE>", "FUCHSIA CITY -"
	db "<CONT>", "SEAFOAM ISLANDS"
	db "<DONE>"
;@ path: text/Route20
_Route20Swimmer1BattleText::
	db TX_START, "The water is"
	db "<LINE>", "shallow here."
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer1EndBattleText::
	db TX_START, "Splash!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer1AfterBattleText::
	db TX_START, "I wish I could"
	db "<LINE>", "ride my #MON."
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer2BattleText::
	db TX_START, "SEAFOAM is a"
	db "<LINE>", "quiet getaway!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer2EndBattleText::
	db TX_START, "Quit it!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer2AfterBattleText::
	db TX_START, "There's a huge"
	db "<LINE>", "cavern underneath"
	db "<CONT>", "this island."
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer3BattleText::
	db TX_START, "I love floating"
	db "<LINE>", "with the fishes!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer3EndBattleText::
	db TX_START, "Yowch!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer3AfterBattleText::
	db TX_START, "Want to float"
	db "<LINE>", "with me?"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer4BattleText::
	db TX_START, "Are you on"
	db "<LINE>", "vacation too?"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer4EndBattleText::
	db TX_START, "No"
	db "<LINE>", "mercy at all!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer4AfterBattleText::
	db TX_START, "SEAFOAM used to"
	db "<LINE>", "be one island!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer5BattleText::
	db TX_START, "Check out my buff"
	db "<LINE>", "physique!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer5EndBattleText::
	db TX_START, "Wimpy!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer5AfterBattleText::
	db TX_START, "I should've been"
	db "<LINE>", "buffing up my"
	db "<CONT>", "#MON, not me!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer6BattleText::
	db TX_START, "Why are you"
	db "<LINE>", "riding a #MON?"
	db "<CONT>", "Can't you swim?"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer6EndBattleText::
	db TX_START, "Ouch!"
	db "<LINE>", "Torpedoed!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer6AfterBattleText::
	db TX_START, "Riding a #MON"
	db "<LINE>", "sure looks fun!"
	db "<DONE>"

;@ path: text/Route20
_Route20CooltrainerMBattleText::
	db TX_START, "I rode my bird"
	db "<LINE>", "#MON here!"
	db "<DONE>"

;@ path: text/Route20
_Route20CooltrainerMEndBattleText::
	db TX_START, "Oh"
	db "<LINE>", "no!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20CooltrainerMAfterBattleText::
	db TX_START, "My birds can't"
	db "<LINE>", "FLY me back!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer7BattleText::
	db TX_START, "My boy friend gave"
	db "<LINE>", "me big pearls!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer7EndBattleText::
	db TX_START, "Don't"
	db "<LINE>", "touch my pearls!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer7AfterBattleText::
	db TX_START, "Will my pearls"
	db "<LINE>", "grow bigger"
	db "<CONT>", "inside CLOYSTER?"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer8BattleText::
	db TX_START, "I swam here from"
	db "<LINE>", "CINNABAR ISLAND!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer8EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "so disappointed!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer8AfterBattleText::
	db TX_START, "#MON have"
	db "<LINE>", "taken over an"
	db "<CONT>", "abandoned mansion"
	db "<CONT>", "on CINNABAR!"
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer9BattleText::
	db TX_START, "CINNABAR, in the"
	db "<LINE>", "west, has a LAB"
	db "<CONT>", "for #MON."
	db "<DONE>"

;@ path: text/Route20
_Route20Swimmer9EndBattleText::
	db TX_START, "Wait!"
	db "<PROMPT>"

;@ path: text/Route20
_Route20Swimmer9AfterBattleText::
	db TX_START, "CINNABAR is a "
	db "<LINE>", "volcanic island!"
	db "<DONE>"

;@ path: text/Route20
_Route20SeafoamIslandsSignText::
	db TX_START, "SEAFOAM ISLANDS"
	db "<DONE>"
;@ path: text/Route21
_Route21Fisher1BattleText::
	db TX_START, "You want to know"
	db "<LINE>", "if the fish are"
	db "<CONT>", "biting?"
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher1EndBattleText::
	db TX_START, "Dang!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Fisher1AfterBattleText::
	db TX_START, "I can't catch"
	db "<LINE>", "anything good!"
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher2BattleText::
	db TX_START, "I got a big haul!"
	db "<LINE>", "Wanna go for it?"
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher2EndBattleText::
	db TX_START, "Darn"
	db "<LINE>", "MAGIKARP!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Fisher2AfterBattleText::
	db TX_START, "I seem to only"
	db "<LINE>", "catch MAGIKARP!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer1BattleText::
	db TX_START, "The sea cleanses"
	db "<LINE>", "my body and soul!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer1EndBattleText::
	db TX_START, "Ayah!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Swimmer1AfterBattleText::
	db TX_START, "I like the"
	db "<LINE>", "mountains too!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer2BattleText::
	db TX_START, "What's wrong with"
	db "<LINE>", "me swimming?"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer2EndBattleText::
	db TX_START, "Cheap"
	db "<LINE>", "shot!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Swimmer2AfterBattleText::
	db TX_START, "I look like what?"
	db "<LINE>", "A studded inner"
	db "<CONT>", "tube? Get lost!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer3BattleText::
	db TX_START, "I caught all my"
	db "<LINE>", "#MON at sea!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer3EndBattleText::
	db TX_START, "Diver!!"
	db "<LINE>", "Down!!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Swimmer3AfterBattleText::
	db TX_START, "Where'd you catch"
	db "<LINE>", "your #MON?"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer4BattleText::
	db TX_START, "Right now, I'm in"
	db "<LINE>", "a triathlon meet!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer4EndBattleText::
	db TX_START, "Pant..."
	db "<LINE>", "pant...pant..."
	db "<PROMPT>"

;@ path: text/Route21
_Route21Swimmer4AfterBattleText::
	db TX_START, "I'm beat!"
	db "<LINE>", "But, I still have"
	db "<CONT>", "the bike race and"
	db "<CONT>", "marathon left!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer5BattleText::
	db TX_START, "Ahh! Feel the sun"
	db "<LINE>", "and the wind!"
	db "<DONE>"

;@ path: text/Route21
_Route21Swimmer5EndBattleText::
	db TX_START, "Yow!"
	db "<LINE>", "I lost!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Swimmer5AfterBattleText::
	db TX_START, "I'm sunburnt to a"
	db "<LINE>", "crisp!"
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher3BattleText::
	db TX_START, "Hey, don't scare"
	db "<LINE>", "away the fish!"
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher3EndBattleText::
	db TX_START, "Sorry!"
	db "<LINE>", "I didn't mean it!"
	db "<PROMPT>"

;@ path: text/Route21
_Route21Fisher3AfterBattleText::
	db TX_START, "I was just angry"
	db "<LINE>", "that I couldn't"
	db "<CONT>", "catch anything."
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher4BattleText::
	db TX_START, "Keep me company"
	db "<LINE>", "'til I get a hit!"
	db "<DONE>"

;@ path: text/Route21
_Route21Fisher4EndBattleText::
	db TX_START, "That"
	db "<LINE>", "burned some time."
	db "<PROMPT>"

;@ path: text/Route21
_Route21Fisher4AfterBattleText::
	db TX_START, "Oh wait! I got a"
	db "<LINE>", "bite! Yeah!"
	db "<DONE>"
;@ path: text/Route22
_Route22RivalBeforeBattleText1::
	db TX_START, "<RIVAL>: Hey!"
	db "<LINE>", "<PLAYER>!"

	db "<PARA>", "You're going to"
	db "<LINE>", "#MON LEAGUE?"

	db "<PARA>", "Forget it! You"
	db "<LINE>", "probably don't"
	db "<CONT>", "have any BADGEs!"

	db "<PARA>", "The guard won't"
	db "<LINE>", "let you through!"

	db "<PARA>", "By the way, did"
	db "<LINE>", "your #MON"
	db "<CONT>", "get any stronger?"
	db "<DONE>"

;@ path: text/Route22
_Route22RivalAfterBattleText1::
	db TX_START, "I heard #MON"
	db "<LINE>", "LEAGUE has many"
	db "<CONT>", "tough trainers!"

	db "<PARA>", "I have to figure"
	db "<LINE>", "out how to get"
	db "<CONT>", "past them!"

	db "<PARA>", "You should quit"
	db "<LINE>", "dawdling and get"
	db "<CONT>", "a move on!"
	db "<DONE>"

;@ path: text/Route22
_Route22Rival1DefeatedText::
	db TX_START, "Awww!"
	db "<LINE>", "You just lucked"
	db "<CONT>", "out!"
	db "<PROMPT>"

;@ path: text/Route22
_Route22Rival1VictoryText::
	db TX_START, "<RIVAL>: What?"
	db "<LINE>", "Why do I have 2"
	db "<CONT>", "#MON?"

	db "<PARA>", "You should catch"
	db "<CONT>", "some more too!"
	db "<PROMPT>"

;@ path: text/Route22
_Route22RivalBeforeBattleText2::
	db TX_START, "<RIVAL>: What?"
	db "<LINE>", "<PLAYER>! What a"
	db "<CONT>", "surprise to see"
	db "<CONT>", "you here!"

	db "<PARA>", "So you're going to"
	db "<LINE>", "#MON LEAGUE?"

	db "<PARA>", "You collected all"
	db "<LINE>", "the BADGEs too?"
	db "<CONT>", "That's cool!"

	db "<PARA>", "Then I'll whip you"
	db "<LINE>", "<PLAYER> as a"
	db "<CONT>", "warm up for"
	db "<CONT>", "#MON LEAGUE!"

	db "<PARA>", "Come on!"
	db "<DONE>"

;@ path: text/Route22
_Route22RivalAfterBattleText2::
	db TX_START, "That loosened me"
	db "<LINE>", "up! I'm ready for"
	db "<CONT>", "#MON LEAGUE!"

	db "<PARA>", "<PLAYER>, you need"
	db "<LINE>", "more practice!"

	db "<PARA>", "But hey, you know"
	db "<LINE>", "that! I'm out of"
	db "<CONT>", "here. Smell ya!"
	db "<DONE>"

;@ path: text/Route22
_Route22Rival2DefeatedText::
	db TX_START, "What!?"

	db "<PARA>", "I was just"
	db "<LINE>", "careless!"
	db "<PROMPT>"

;@ path: text/Route22
_Route22Rival2VictoryText::
	db TX_START, "<RIVAL>: Hahaha!"
	db "<LINE>", "<PLAYER>! That's"
	db "<CONT>", "your best? You're"
	db "<CONT>", "nowhere near as"
	db "<CONT>", "good as me, pal!"

	db "<PARA>", "Go train some"
	db "<LINE>", "more! You loser!"
	db "<PROMPT>"

;@ path: text/Route22
_Route22PokemonLeagueSignText::
	db TX_START, "#MON LEAGUE"
	db "<LINE>", "Front Gate"
	db "<DONE>"
;@ path: text/Route23
_Route23YouDontHaveTheBadgeYetText::
	db TX_START, "You can pass here"
	db "<LINE>", "only if you have"
	db "<CONT>", "the @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"

	db "<PARA>", "You don't have the"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, " yet!"

	db "<PARA>", "You have to have"
	db "<LINE>", "it to get to"
	db "<CONT>", "#MON LEAGUE!@"
	db TX_END

;@ path: text/Route23
_Route23OhThatIsTheBadgeText::
	db TX_START, "You can pass here"
	db "<LINE>", "only if you have"
	db "<CONT>", "the @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"

	db "<PARA>", "Oh! That is the"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/Route23
_Route23GoRightAheadText::
	db TX_START

	db "<PARA>", "OK then! Please,"
	db "<LINE>", "go right ahead!"
	db "<DONE>"

;@ path: text/Route23
_Route23VictoryRoadGateSignText::
	db TX_START, "VICTORY ROAD GATE"
	db "<LINE>", "- #MON LEAGUE"
	db "<DONE>"
;@ path: text/Route24
_Route24CooltrainerM1YouBeatOurContestText::
	db TX_START, "Congratulations!"
	db "<LINE>", "You beat our 5"
	db "<CONT>", "contest trainers!@"
	db TX_END

;@ path: text/Route24
_Route24CooltrainerM1YouJustEarnedAPrizeText::
	db TX_START

	db "<PARA>", "You just earned a"
	db "<LINE>", "fabulous prize!"
	db "<PROMPT>"

;@ path: text/Route24
_Route24CooltrainerM1ReceivedNuggetText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/Route24
_Route24CooltrainerM1NoRoomText::
	db TX_START, "You don't have"
	db "<LINE>", "any room!"
	db "<DONE>"

;@ path: text/Route24
_Route24CooltrainerM1JoinTeamRocketText::
	db TX_START, "By the way, would"
	db "<LINE>", "you like to join"
	db "<CONT>", "TEAM ROCKET?"

	db "<PARA>", "We're a group"
	db "<LINE>", "dedicated to evil"
	db "<CONT>", "using #MON!"

	db "<PARA>", "Want to join?"

	db "<PARA>", "Are you sure?"

	db "<PARA>", "Come on, join us!"

	db "<PARA>", "I'm telling you"
	db "<LINE>", "to join!"

	db "<PARA>", "OK, you need"
	db "<LINE>", "convincing!"

	db "<PARA>", "I'll make you an"
	db "<LINE>", "offer you can't"
	db "<CONT>", "refuse!"
	db "<DONE>"

;@ path: text/Route24
_Route24CooltrainerM1DefeatedText::
	db TX_START, "Arrgh!"
	db "<LINE>", "You are good!"
	db "<PROMPT>"

;@ path: text/Route24
_Route24CooltrainerM1YouCouldBecomeATopLeaderText::
	db TX_START, "With your ability,"
	db "<LINE>", "you could become"
	db "<CONT>", "a top leader in"
	db "<CONT>", "TEAM ROCKET!"
	db "<DONE>"

;@ path: text/Route24
_Route24CooltrainerM2BattleText::
	db TX_START, "I saw your feat"
	db "<LINE>", "from the grass!"
	db "<DONE>"


SECTION "Text 6", ROMX

;@ path: text/Route24_2
_Route24CooltrainerM2EndBattleText::
	db TX_START, "I"
	db "<LINE>", "thought not!"
	db "<PROMPT>"

;@ path: text/Route24_2
_Route24CooltrainerM2AfterBattleText::
	db TX_START, "I hid because the"
	db "<LINE>", "people on the"
	db "<CONT>", "bridge scared me!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24CooltrainerM3BattleText::
	db TX_START, "OK! I'm No. 5!"
	db "<LINE>", "I'll stomp you!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24CooltrainerM3EndBattleText::
	db TX_START, "Whoa!"
	db "<LINE>", "Too much!"
	db "<PROMPT>"

;@ path: text/Route24_2
_Route24CooltrainerM3AfterBattleText::
	db TX_START, "I did my best, I"
	db "<LINE>", "have no regrets!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24CooltrainerF1BattleText::
	db TX_START, "I'm No. 4!"
	db "<LINE>", "Getting tired?"
	db "<DONE>"

;@ path: text/Route24_2
_Route24CooltrainerF1EndBattleText::
	db TX_START, "I lost"
	db "<LINE>", "too!"
	db "<PROMPT>"

;@ path: text/Route24_2
_Route24CooltrainerF1AfterBattleText::
	db TX_START, "I did my best, so"
	db "<LINE>", "I've no regrets!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24Youngster1BattleText::
	db TX_START, "Here's No. 3!"
	db "<LINE>", "I won't be easy!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24Youngster1EndBattleText::
	db TX_START, "Ow!"
	db "<LINE>", "Stomped flat!"
	db "<PROMPT>"

;@ path: text/Route24_2
_Route24Youngster1AfterBattleText::
	db TX_START, "I did my best, I"
	db "<LINE>", "have no regrets!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24CooltrainerF2BattleText::
	db TX_START, "I'm second!"
	db "<LINE>", "Now it's serious!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24CooltrainerF2EndBattleText::
	db TX_START, "How could I"
	db "<LINE>", "lose?"
	db "<PROMPT>"

;@ path: text/Route24_2
_Route24CooltrainerF2AfterBattleText::
	db TX_START, "I did my best, I"
	db "<LINE>", "have no regrets!"
	db "<DONE>"

;@ path: text/Route24_2
_Route24Youngster2BattleText::
	db TX_START, "This is NUGGET"
	db "<LINE>", "BRIDGE! Beat us 5"
	db "<CONT>", "trainers and win"
	db "<CONT>", "a fabulous prize!"

	db "<PARA>", "Think you got"
	db "<LINE>", "what it takes?"
	db "<DONE>"

;@ path: text/Route24_2
_Route24Youngster2EndBattleText::
	db TX_START, "Whoo!"
	db "<LINE>", "Good stuff!"
	db "<PROMPT>"

;@ path: text/Route24_2
_Route24Youngster2AfterBattleText::
	db TX_START, "I did my best, I"
	db "<LINE>", "have no regrets!"
	db "<DONE>"
;@ path: text/Route25
_Route25Youngster1BattleText::
	db TX_START, "Local trainers"
	db "<LINE>", "come here to"
	db "<CONT>", "practice!"
	db "<DONE>"

;@ path: text/Route25
_Route25Youngster1EndBattleText::
	db TX_START, "You're"
	db "<LINE>", "decent."
	db "<PROMPT>"

;@ path: text/Route25
_Route25Youngster1AfterBattleText::
	db TX_START, "All #MON have"
	db "<LINE>", "weaknesses. It's"
	db "<CONT>", "best to raise"
	db "<CONT>", "different kinds."
	db "<DONE>"

;@ path: text/Route25
_Route25Youngster2BattleText::
	db TX_START, "Dad took me to a"
	db "<LINE>", "great party on"
	db "<CONT>", "S.S.ANNE at"
	db "<CONT>", "VERMILION CITY!"
	db "<DONE>"

;@ path: text/Route25
_Route25Youngster2EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "not mad!"
	db "<PROMPT>"

;@ path: text/Route25
_Route25Youngster2AfterBattleText::
	db TX_START, "On S.S.ANNE, I"
	db "<LINE>", "saw trainers from"
	db "<CONT>", "around the world."
	db "<DONE>"

;@ path: text/Route25
_Route25CooltrainerMBattleText::
	db TX_START, "I'm a cool guy."
	db "<LINE>", "I've got a girl"
	db "<CONT>", "friend!"
	db "<DONE>"

;@ path: text/Route25
_Route25CooltrainerMEndBattleText::
	db TX_START, "Aww,"
	db "<LINE>", "darn..."
	db "<PROMPT>"

;@ path: text/Route25
_Route25CooltrainerMAfterBattleText::
	db TX_START, "Oh well. My girl"
	db "<LINE>", "will cheer me up."
	db "<DONE>"

;@ path: text/Route25
_Route25CooltrainerF1BattleText::
	db TX_START, "Hi! My boy"
	db "<LINE>", "friend is cool!"
	db "<DONE>"

;@ path: text/Route25
_Route25CooltrainerF1EndBattleText::
	db TX_START, "I was in"
	db "<LINE>", "bad condition!"
	db "<PROMPT>"

;@ path: text/Route25
_Route25CooltrainerF1AfterBattleText::
	db TX_START, "I wish my guy was"
	db "<LINE>", "as good as you!"
	db "<DONE>"

;@ path: text/Route25
_Route25Youngster3BattleText::
	db TX_START, "I knew I had to"
	db "<LINE>", "fight you!"
	db "<DONE>"

;@ path: text/Route25
_Route25Youngster3EndBattleText::
	db TX_START, "I knew"
	db "<LINE>", "I'd lose too!"
	db "<PROMPT>"

;@ path: text/Route25
_Route25Youngster3AfterBattleText::
	db TX_START, "If your #MON"
	db "<LINE>", "gets confused or"
	db "<CONT>", "falls asleep,"
	db "<CONT>", "switch it!"
	db "<DONE>"

;@ path: text/Route25
_Route25CooltrainerF2BattleText::
	db TX_START, "My friend has a"
	db "<LINE>", "cute #MON."
	db "<CONT>", "I'm so jealous!"
	db "<DONE>"

;@ path: text/Route25
_Route25CooltrainerF2EndBattleText::
	db TX_START, "I'm"
	db "<LINE>", "not so jealous!"
	db "<PROMPT>"

;@ path: text/Route25
_Route25CooltrainerF2AfterBattleText::
	db TX_START, "You came from MT."
	db "<LINE>", "MOON? May I have"
	db "<CONT>", "a CLEFAIRY?"
	db "<DONE>"

;@ path: text/Route25
_Route25Hiker1BattleText::
	db TX_START, "I just got down"
	db "<LINE>", "from MT.MOON,"
	db "<CONT>", "but I'm ready!"
	db "<DONE>"

;@ path: text/Route25
_Route25Hiker1EndBattleText::
	db TX_START, "You"
	db "<LINE>", "worked hard!"
	db "<PROMPT>"

;@ path: text/Route25
_Route25Hiker1AfterBattleText::
	db TX_START, "Drat!"
	db "<LINE>", "A ZUBAT bit me"
	db "<CONT>", "back in there."
	db "<DONE>"

;@ path: text/Route25
_Route25Hiker2BattleText::
	db TX_START, "I'm off to see a"
	db "<LINE>", "#MON collector"
	db "<CONT>", "at the cape!"
	db "<DONE>"

;@ path: text/Route25
_Route25Hiker2EndBattleText::
	db TX_START, "You"
	db "<LINE>", "got me."
	db "<PROMPT>"

;@ path: text/Route25
_Route25Hiker2AfterBattleText::
	db TX_START, "The collector has"
	db "<LINE>", "many rare kinds"
	db "<CONT>", "of #MON."
	db "<DONE>"

;@ path: text/Route25
_Route25Hiker3BattleText::
	db TX_START, "You're going to"
	db "<LINE>", "see BILL? First,"
	db "<CONT>", "let's fight!"
	db "<DONE>"

;@ path: text/Route25
_Route25Hiker3EndBattleText::
	db TX_START, "You're"
	db "<LINE>", "something."
	db "<PROMPT>"

;@ path: text/Route25
_Route25Hiker3AfterBattleText::
	db TX_START, "The trail below"
	db "<LINE>", "is a shortcut to"
	db "<CONT>", "CERULEAN CITY."
	db "<DONE>"

;@ path: text/Route25
_Route25BillSignText::
	db TX_START, "SEA COTTAGE"
	db "<LINE>", "BILL lives here!"
	db "<DONE>"

;@ path: data/text/text_3
_FileDataDestroyedText::
	db TX_START, "The file data is"
	db "<LINE>", "destroyed!"
	db "<PROMPT>"

;@ path: data/text/text_3
_WouldYouLikeToSaveText::
	db TX_START, "Would you like to"
	db "<LINE>", "SAVE the game?"
	db "<DONE>"

;@ path: data/text/text_3
_GameSavedText::
	db TX_START, "<PLAYER> saved"
	db "<LINE>", "the game!"
	db "<DONE>"

;@ path: data/text/text_3
_OlderFileWillBeErasedText::
	db TX_START, "The older file"
	db "<LINE>", "will be erased to"
	db "<CONT>", "save. Okay?"
	db "<DONE>"

;@ path: data/text/text_3
_WhenYouChangeBoxText::
	db TX_START, "When you change a"
	db "<LINE>", "#MON BOX, data"
	db "<CONT>", "will be saved."

	db "<PARA>", "Is that okay?"
	db "<DONE>"

;@ path: data/text/text_3
_ChooseABoxText::
	db TX_START, "Choose a"
	db "<LINE>", "<PKMN> BOX.@"
	db TX_END

;@ path: data/text/text_3
_EvolvedText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, " evolved"
	db "<DONE>"

;@ path: data/text/text_3
_IntoText::
	db TX_START
	db "<LINE>", "into @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_3
_StoppedEvolvingText::
	db TX_START, "Huh? @"
	db TX_RAM
	dw wStringBuffer
	db TX_START
	db "<LINE>", "stopped evolving!"
	db "<PROMPT>"

;@ path: data/text/text_3
_IsEvolvingText::
	db TX_START, "What? @"
	db TX_RAM
	dw wStringBuffer
	db TX_START
	db "<LINE>", "is evolving!"
	db "<DONE>"

;@ path: data/text/text_3
_FellAsleepText::
	db TX_START, "<TARGET>"
	db "<LINE>", "fell asleep!"
	db "<PROMPT>"

;@ path: data/text/text_3
_AlreadyAsleepText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "already asleep!"
	db "<PROMPT>"

;@ path: data/text/text_3
_PoisonedText::
	db TX_START, "<TARGET>"
	db "<LINE>", "was poisoned!"
	db "<PROMPT>"

;@ path: data/text/text_3
_BadlyPoisonedText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "badly poisoned!"
	db "<PROMPT>"

;@ path: data/text/text_3
_BurnedText::
	db TX_START, "<TARGET>"
	db "<LINE>", "was burned!"
	db "<PROMPT>"

;@ path: data/text/text_3
_FrozenText::
	db TX_START, "<TARGET>"
	db "<LINE>", "was frozen solid!"
	db "<PROMPT>"

;@ path: data/text/text_3
_FireDefrostedText::
	db TX_START, "Fire defrosted"
	db "<LINE>", "<TARGET>!"
	db "<PROMPT>"

;@ path: data/text/text_3
_MonsStatsRoseText::
	db TX_START, "<USER>'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "@"
	db TX_END

;@ path: data/text/text_3
_GreatlyRoseText::
	db TX_START, "<SCROLL>greatly@"
	db TX_END

;@ path: data/text/text_3
_RoseText::
	db TX_START, " rose!"
	db "<PROMPT>"

;@ path: data/text/text_3
_MonsStatsFellText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "@"
	db TX_END

;@ path: data/text/text_3
_GreatlyFellText::
	db TX_START, "<SCROLL>greatly@"
	db TX_END

;@ path: data/text/text_3
_FellText::
	db TX_START, " fell!"
	db "<PROMPT>"

;@ path: data/text/text_3
_RanFromBattleText::
	db TX_START, "<USER>"
	db "<LINE>", "ran from battle!"
	db "<PROMPT>"

;@ path: data/text/text_3
_RanAwayScaredText::
	db TX_START, "<TARGET>"
	db "<LINE>", "ran away scared!"
	db "<PROMPT>"

;@ path: data/text/text_3
_WasBlownAwayText::
	db TX_START, "<TARGET>"
	db "<LINE>", "was blown away!"
	db "<PROMPT>"

;@ path: data/text/text_3
_ChargeMoveEffectText::
	db TX_START, "<USER>@"
	db TX_END

;@ path: data/text/text_3
_MadeWhirlwindText::
	db TX_START
	db "<LINE>", "made a whirlwind!"
	db "<PROMPT>"

;@ path: data/text/text_3
_TookInSunlightText::
	db TX_START
	db "<LINE>", "took in sunlight!"
	db "<PROMPT>"

;@ path: data/text/text_3
_LoweredItsHeadText::
	db TX_START
	db "<LINE>", "lowered its head!"
	db "<PROMPT>"

;@ path: data/text/text_3
_SkyAttackGlowingText::
	db TX_START
	db "<LINE>", "is glowing!"
	db "<PROMPT>"

;@ path: data/text/text_3
_FlewUpHighText::
	db TX_START
	db "<LINE>", "flew up high!"
	db "<PROMPT>"

;@ path: data/text/text_3
_DugAHoleText::
	db TX_START
	db "<LINE>", "dug a hole!"
	db "<PROMPT>"

;@ path: data/text/text_3
_BecameConfusedText::
	db TX_START, "<TARGET>"
	db "<LINE>", "became confused!"
	db "<PROMPT>"

;@ path: data/text/text_3
_MimicLearnedMoveText::
	db TX_START, "<USER>"
	db "<LINE>", "learned"
	db "<CONT>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_3
_MoveWasDisabledText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, " was"
	db "<CONT>", "disabled!"
	db "<PROMPT>"

;@ path: data/text/text_3
_NothingHappenedText::
	db TX_START, "Nothing happened!"
	db "<PROMPT>"

;@ path: data/text/text_3
_NoEffectText::
	db TX_START, "No effect!"
	db "<PROMPT>"

;@ path: data/text/text_3
_ButItFailedText::
	db TX_START, "But, it failed! "
	db "<PROMPT>"

;@ path: data/text/text_3
_DidntAffectText::
	db TX_START, "It didn't affect"
	db "<LINE>", "<TARGET>!"
	db "<PROMPT>"

;@ path: data/text/text_3
_IsUnaffectedText::
	db TX_START, "<TARGET>"
	db "<LINE>", "is unaffected!"
	db "<PROMPT>"

;@ path: data/text/text_3
_ParalyzedMayNotAttackText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "paralyzed! It may"
	db "<CONT>", "not attack!"
	db "<PROMPT>"

;@ path: data/text/text_3
_SubstituteText::
	db TX_START, "It created a"
	db "<LINE>", "SUBSTITUTE!"
	db "<PROMPT>"

;@ path: data/text/text_3
_HasSubstituteText::
	db TX_START, "<USER>"
	db "<LINE>", "has a SUBSTITUTE!"
	db "<PROMPT>"

;@ path: data/text/text_3
_TooWeakSubstituteText::
	db TX_START, "Too weak to make"
	db "<LINE>", "a SUBSTITUTE!"
	db "<PROMPT>"

;@ path: data/text/text_3
_CoinsScatteredText::
	db TX_START, "Coins scattered"
	db "<LINE>", "everywhere!"
	db "<PROMPT>"

;@ path: data/text/text_3
_GettingPumpedText::
	db TX_START, "<USER>'s"
	db "<LINE>", "getting pumped!"
	db "<PROMPT>"

;@ path: data/text/text_3
_WasSeededText::
	db TX_START, "<TARGET>"
	db "<LINE>", "was seeded!"
	db "<PROMPT>"

;@ path: data/text/text_3
_EvadedAttackText::
	db TX_START, "<TARGET>"
	db "<LINE>", "evaded attack!"
	db "<PROMPT>"

;@ path: data/text/text_3
_HitWithRecoilText::
	db TX_START, "<USER>'s"
	db "<LINE>", "hit with recoil!"
	db "<PROMPT>"

;@ path: data/text/text_3
_ConvertedTypeText::
	db TX_START, "Converted type to"
	db "<LINE>", "<TARGET>'s!"
	db "<PROMPT>"

;@ path: data/text/text_3
_StatusChangesEliminatedText::
	db TX_START, "All STATUS changes"
	db "<LINE>", "are eliminated!"
	db "<PROMPT>"

;@ path: data/text/text_3
_StartedSleepingEffect::
	db TX_START, "<USER>"
	db "<LINE>", "started sleeping!"
	db "<DONE>"

;@ path: data/text/text_3
_FellAsleepBecameHealthyText::
	db TX_START, "<USER>"
	db "<LINE>", "fell asleep and"
	db "<CONT>", "became healthy!"
	db "<DONE>"

;@ path: data/text/text_3
_RegainedHealthText::
	db TX_START, "<USER>"
	db "<LINE>", "regained health!"
	db "<PROMPT>"

;@ path: data/text/text_3
_TransformedText::
	db TX_START, "<USER>"
	db "<LINE>", "transformed into"
	db "<CONT>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_3
_LightScreenProtectedText::
	db TX_START, "<USER>'s"
	db "<LINE>", "protected against"
	db "<CONT>", "special attacks!"
	db "<PROMPT>"

;@ path: data/text/text_3
_ReflectGainedArmorText::
	db TX_START, "<USER>"
	db "<LINE>", "gained armor!"
	db "<PROMPT>"

;@ path: data/text/text_3
_ShroudedInMistText::
	db TX_START, "<USER>'s"
	db "<LINE>", "shrouded in mist!"
	db "<PROMPT>"

;@ path: data/text/text_3
_SuckedHealthText::
	db TX_START, "Sucked health from"
	db "<LINE>", "<TARGET>!"
	db "<PROMPT>"

;@ path: data/text/text_3
_DreamWasEatenText::
	db TX_START, "<TARGET>'s"
	db "<LINE>", "dream was eaten!"
	db "<PROMPT>"

;@ path: data/text/text_3
_TradeCenterOpponentText::
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_3
_ColosseumOpponentText::
	db TX_START, "!"
	db "<DONE>"

;@ path: text/RedsHouse1F
_RedsHouse1FMomWakeUpText::
	db TX_START, "MOM: Right."
	db "<LINE>", "All boys leave"
	db "<CONT>", "home some day."
	db "<CONT>", "It said so on TV."

	db "<PARA>", "PROF.OAK, next"
	db "<LINE>", "door, is looking"
	db "<CONT>", "for you."
	db "<DONE>"

;@ path: text/RedsHouse1F
_RedsHouse1FMomYouShouldRestText::
	db TX_START, "MOM: <PLAYER>!"
	db "<LINE>", "You should take a"
	db "<CONT>", "quick rest."
	db "<PROMPT>"

;@ path: text/RedsHouse1F
_RedsHouse1FMomLookingGreatText::
	db TX_START, "MOM: Oh good!"
	db "<LINE>", "You and your"
	db "<CONT>", "#MON are"
	db "<CONT>", "looking great!"
	db "<CONT>", "Take care now!"
	db "<DONE>"

;@ path: text/RedsHouse1F
_RedsHouse1FTVStandByMeMovieText::
	db TX_START, "There's a movie"
	db "<LINE>", "on TV. Four boys"
	db "<CONT>", "are walking on"
	db "<CONT>", "railroad tracks."

	db "<PARA>", "I better go too."
	db "<DONE>"

;@ path: text/RedsHouse1F
_RedsHouse1FTVWrongSideText::
	db TX_START, "Oops, wrong side."
	db "<DONE>"
;@ path: text/BluesHouse
_BluesHouseDaisyRivalAtLabText::
	db TX_START, "Hi <PLAYER>!"
	db "<LINE>", "<RIVAL> is out at"
	db "<CONT>", "Grandpa's lab."
	db "<DONE>"

;@ path: text/BluesHouse
_BluesHouseDaisyOfferMapText::
	db TX_START, "Grandpa asked you"
	db "<LINE>", "to run an errand?"
	db "<CONT>", "Here, this will"
	db "<CONT>", "help you!"
	db "<PROMPT>"

;@ path: text/BluesHouse
_GotMapText::
	db TX_START, "<PLAYER> got a"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/BluesHouse
_BluesHouseDaisyBagFullText::
	db TX_START, "You have too much"
	db "<LINE>", "stuff with you."
	db "<DONE>"

;@ path: text/BluesHouse
_BluesHouseDaisyUseMapText::
	db TX_START, "Use the TOWN MAP"
	db "<LINE>", "to find out where"
	db "<CONT>", "you are."
	db "<DONE>"

;@ path: text/BluesHouse
_BluesHouseDaisyWalkingText::
	db TX_START, "#MON are living"
	db "<LINE>", "things! If they"
	db "<CONT>", "get tired, give"
	db "<CONT>", "them a rest!"
	db "<DONE>"

;@ path: text/BluesHouse
_BluesHouseTownMapText::
	db TX_START, "It's a big map!"
	db "<LINE>", "This is useful!"
	db "<DONE>"
;@ path: text/OaksLab
_OaksLabRivalGrampsIsntAroundText::
	db TX_START, "<RIVAL>: Yo"
	db "<LINE>", "<PLAYER>! Gramps"
	db "<CONT>", "isn't around!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalGoAheadAndChooseText::
	db TX_START, "<RIVAL>: Heh, I"
	db "<LINE>", "don't need to be"
	db "<CONT>", "greedy like you!"

	db "<PARA>", "Go ahead and"
	db "<LINE>", "choose, <PLAYER>!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalMyPokemonLooksStrongerText::
	db TX_START, "<RIVAL>: My"
	db "<LINE>", "#MON looks a"
	db "<CONT>", "lot stronger."
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabThoseArePokeBallsText::
	db TX_START, "Those are #"
	db "<LINE>", "BALLs. They"
	db "<CONT>", "contain #MON!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabYouWantCharmanderText::
	db TX_START, "So! You want the"
	db "<LINE>", "fire #MON,"
	db "<CONT>", "CHARMANDER?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabYouWantSquirtleText::
	db TX_START, "So! You want the"
	db "<LINE>", "water #MON,"
	db "<CONT>", "SQUIRTLE?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabYouWantBulbasaurText::
	db TX_START, "So! You want the"
	db "<LINE>", "plant #MON,"
	db "<CONT>", "BULBASAUR?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabMonEnergeticText::
	db TX_START, "This #MON is"
	db "<LINE>", "really energetic!"
	db "<PROMPT>"

;@ path: text/OaksLab
_OaksLabReceivedMonText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/OaksLab
_OaksLabLastMonText::
	db TX_START, "That's PROF.OAK's"
	db "<LINE>", "last #MON!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1WhichPokemonDoYouWantText::
	db TX_START, "OAK: Now, <PLAYER>,"
	db "<LINE>", "which #MON do"
	db "<CONT>", "you want?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1YourPokemonCanFightText::
	db TX_START, "OAK: If a wild"
	db "<LINE>", "#MON appears,"
	db "<CONT>", "your #MON can"
	db "<CONT>", "fight against it!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1RaiseYourYoungPokemonText::
	db TX_START, "OAK: <PLAYER>,"
	db "<LINE>", "raise your young"
	db "<CONT>", "#MON by making"
	db "<CONT>", "it fight!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1DeliverParcelText::
	db TX_START, "OAK: Oh, <PLAYER>!"

	db "<PARA>", "How is my old"
	db "<LINE>", "#MON?"

	db "<PARA>", "Well, it seems to"
	db "<LINE>", "like you a lot."

	db "<PARA>", "You must be"
	db "<LINE>", "talented as a"
	db "<CONT>", "#MON trainer!"

	db "<PARA>", "What? You have"
	db "<LINE>", "something for me?"

	db "<PARA>", "<PLAYER> delivered"
	db "<LINE>", "OAK's PARCEL.@"
	db TX_END

;@ path: text/OaksLab
_OaksLabOak1ParcelThanksText::
	db TX_START

	db "<PARA>", "Ah! This is the"
	db "<LINE>", "custom # BALL"
	db "<CONT>", "I ordered!"
	db "<CONT>", "Thank you!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1PokemonAroundTheWorldText::
	db TX_START, "#MON around the"
	db "<LINE>", "world wait for"
	db "<CONT>", "you, <PLAYER>!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1ReceivedPokeballsText::
	db TX_START, "OAK: You can't get"
	db "<LINE>", "detailed data on"
	db "<CONT>", "#MON by just"
	db "<CONT>", "seeing them."

	db "<PARA>", "You must catch"
	db "<LINE>", "them! Use these"
	db "<CONT>", "to capture wild"
	db "<CONT>", "#MON."

	db "<PARA>", "<PLAYER> got 5"
	db "<LINE>", "# BALLs!@"
	db TX_END

;@ path: text/OaksLab
_OaksLabGivePokeballsExplanationText::
	db TX_START

	db "<PARA>", "When a wild"
	db "<LINE>", "#MON appears,"
	db "<CONT>", "it's fair game."

	db "<PARA>", "Just throw a #"
	db "<LINE>", "BALL at it and try"
	db "<LINE>", "to catch it!"

	db "<PARA>", "This won't always"
	db "<LINE>", "work, though."

	db "<PARA>", "A healthy #MON"
	db "<LINE>", "could escape. You"
	db "<CONT>", "have to be lucky!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1ComeSeeMeSometimesText::
	db TX_START, "OAK: Come see me"
	db "<LINE>", "sometimes."

	db "<PARA>", "I want to know how"
	db "<LINE>", "your #DEX is"
	db "<CONT>", "coming along."
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak1HowIsYourPokedexComingText::
	db TX_START, "OAK: Good to see "
	db "<LINE>", "you! How is your "
	db "<CONT>", "#DEX coming? "
	db "<CONT>", "Here, let me take"
	db "<CONT>", "a look!"
	db "<PROMPT>"

;@ path: text/OaksLab
_OaksLabPokedexText::
	db TX_START, "It's encyclopedia-"
	db "<LINE>", "like, but the"
	db "<CONT>", "pages are blank!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOak2Text::
	db TX_START, "?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabGirlText::
	db TX_START, "PROF.OAK is the"
	db "<LINE>", "authority on"
	db "<CONT>", "#MON!"

	db "<PARA>", "Many #MON"
	db "<LINE>", "trainers hold him"
	db "<CONT>", "in high regard!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalFedUpWithWaitingText::
	db TX_START, "<RIVAL>: Gramps!"
	db "<LINE>", "I'm fed up with"
	db "<CONT>", "waiting!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOakChooseMonText::
	db TX_START, "OAK: <RIVAL>?"
	db "<LINE>", "Let me think..."

	db "<PARA>", "Oh, that's right,"
	db "<LINE>", "I told you to"
	db "<CONT>", "come! Just wait!"

	db "<PARA>", "Here, <PLAYER>!"

	db "<PARA>", "There are 3"
	db "<LINE>", "#MON here!"

	db "<PARA>", "Haha!"

	db "<PARA>", "They are inside"
	db "<LINE>", "the # BALLs."

	db "<PARA>", "When I was young,"
	db "<LINE>", "I was a serious"
	db "<CONT>", "#MON trainer!"

	db "<PARA>", "In my old age, I"
	db "<LINE>", "have only 3 left,"
	db "<CONT>", "but you can have"
	db "<CONT>", "one! Choose!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalWhatAboutMeText::
	db TX_START, "<RIVAL>: Hey!"
	db "<LINE>", "Gramps! What"
	db "<CONT>", "about me?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOakBePatientText::
	db TX_START, "OAK: Be patient!"
	db "<LINE>", "<RIVAL>, you can"
	db "<CONT>", "have one too!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOakDontGoAwayYetText::
	db TX_START, "OAK: Hey! Don't go"
	db "<LINE>", "away yet!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalIllTakeThisOneText::
	db TX_START, "<RIVAL>: I'll take"
	db "<LINE>", "this one, then!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalReceivedMonText::
	db TX_START, "<RIVAL> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/OaksLab
_OaksLabRivalIllTakeYouOnText::
	db TX_START, "<RIVAL>: Wait"
	db "<LINE>", "<PLAYER>!"
	db "<CONT>", "Let's check out"
	db "<CONT>", "our #MON!"

	db "<PARA>", "Come on, I'll take"
	db "<LINE>", "you on!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalIPickedTheWrongPokemonText::
	db TX_START, "WHAT?"
	db "<LINE>", "Unbelievable!"
	db "<CONT>", "I picked the"
	db "<CONT>", "wrong #MON!"
	db "<PROMPT>"

;@ path: text/OaksLab
_OaksLabRivalAmIGreatOrWhatText::
	db TX_START, "<RIVAL>: Yeah! Am"
	db "<LINE>", "I great or what?"
	db "<PROMPT>"

;@ path: text/OaksLab
_OaksLabRivalSmellYouLaterText::
	db TX_START, "<RIVAL>: Okay!"
	db "<LINE>", "I'll make my"
	db "<CONT>", "#MON fight to"
	db "<CONT>", "toughen it up!"

	db "<PARA>", "<PLAYER>! Gramps!"
	db "<LINE>", "Smell you later!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalGrampsText::
	db TX_START, "<RIVAL>: Gramps!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalWhatDidYouCallMeForText::
	db TX_START, "<RIVAL>: What did"
	db "<LINE>", "you call me for?"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOakIHaveARequestText::
	db TX_START, "OAK: Oh right! I"
	db "<LINE>", "have a request"
	db "<CONT>", "of you two."
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOakMyInventionPokedexText::
	db TX_START, "On the desk there"
	db "<LINE>", "is my invention,"
	db "<CONT>", "#DEX!"

	db "<PARA>", "It automatically"
	db "<LINE>", "records data on"
	db "<CONT>", "#MON you've"
	db "<CONT>", "seen or caught!"

	db "<PARA>", "It's a hi-tech"
	db "<LINE>", "encyclopedia!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabOakGotPokedexText::
	db TX_START, "OAK: <PLAYER> and"
	db "<LINE>", "<RIVAL>! Take"
	db "<CONT>", "these with you!"

	db "<PARA>", "<PLAYER> got"
	db "<LINE>", "#DEX from OAK!@"
	db TX_END

;@ path: text/OaksLab
_OaksLabOakThatWasMyDreamText::
	db TX_START, "To make a complete"
	db "<LINE>", "guide on all the"
	db "<CONT>", "#MON in the"
	db "<CONT>", "world..."

	db "<PARA>", "That was my dream!"

	db "<PARA>", "But, I'm too old!"
	db "<LINE>", "I can't do it!"

	db "<PARA>", "So, I want you two"
	db "<LINE>", "to fulfill my"
	db "<CONT>", "dream for me!"

	db "<PARA>", "Get moving, you"
	db "<LINE>", "two!"

	db "<PARA>", "This is a great"
	db "<LINE>", "undertaking in"
	db "<CONT>", "#MON history!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabRivalLeaveItAllToMeText::
	db TX_START, "<RIVAL>: Alright"
	db "<LINE>", "Gramps! Leave it"
	db "<CONT>", "all to me!"

	db "<PARA>", "<PLAYER>, I hate to"
	db "<LINE>", "say it, but I"
	db "<CONT>", "don't need you!"

	db "<PARA>", "I know! I'll"
	db "<LINE>", "borrow a TOWN MAP"
	db "<CONT>", "from my sis!"

	db "<PARA>", "I'll tell her not"
	db "<LINE>", "to lend you one,"
	db "<CONT>", "<PLAYER>! Hahaha!"
	db "<DONE>"

;@ path: text/OaksLab
_OaksLabScientistText::
	db TX_START, "I study #MON as"
	db "<LINE>", "PROF.OAK's AIDE."
	db "<DONE>"
;@ path: text/pokedex_ratings
_DexCompletionText::
	db TX_START, "#DEX comp-"
	db "<LINE>", "letion is:"

	db "<PARA>", "@"
	db TX_NUM
	dw hDexRatingNumMonsSeen
	db ((1) << 4) | (3)
	db TX_START, " #MON seen"
	db "<LINE>", "@"
	db TX_NUM
	dw hDexRatingNumMonsOwned
	db ((1) << 4) | (3)
	db TX_START, " #MON owned"

	db "<PARA>", "PROF.OAK's"
	db "<LINE>", "Rating:"
	db "<PROMPT>"

;@ path: text/pokedex_ratings
_DexRatingText_Own0To9::
	db TX_START, "You still have"
	db "<LINE>", "lots to do."
	db "<CONT>", "Look for #MON"
	db "<CONT>", "in grassy areas!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own10To19::
	db TX_START, "You're on the"
	db "<LINE>", "right track! "
	db "<CONT>", "Get a FLASH HM"
	db "<CONT>", "from my AIDE!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own20To29::
	db TX_START, "You still need"
	db "<LINE>", "more #MON!"
	db "<CONT>", "Try to catch"
	db "<CONT>", "other species!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own30To39::
	db TX_START, "Good, you're"
	db "<LINE>", "trying hard!"
	db "<CONT>", "Get an ITEMFINDER"
	db "<CONT>", "from my AIDE!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own40To49::
	db TX_START, "Looking good!"
	db "<LINE>", "Go find my AIDE"
	db "<CONT>", "when you get 50!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own50To59::
	db TX_START, "You finally got at"
	db "<LINE>", "least 50 species!"
	db "<CONT>", "Be sure to get"
	db "<CONT>", "EXP.ALL from my"
	db "<CONT>", "AIDE!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own60To69::
	db TX_START, "Ho! This is geting"
	db "<LINE>", "even better!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own70To79::
	db TX_START, "Very good!"
	db "<LINE>", "Go fish for some"
	db "<CONT>", "marine #MON!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own80To89::
	db TX_START, "Wonderful!"
	db "<LINE>", "Do you like to"
	db "<CONT>", "collect things?"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own90To99::
	db TX_START, "I'm impressed!"
	db "<LINE>", "It must have been"
	db "<CONT>", "difficult to do!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own100To109::
	db TX_START, "You finally got at"
	db "<LINE>", "least 100 species!"
	db "<CONT>", "I can't believe"
	db "<CONT>", "how good you are!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own110To119::
	db TX_START, "You even have the"
	db "<LINE>", "evolved forms of"
	db "<CONT>", "#MON! Super!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own120To129::
	db TX_START, "Excellent! Trade"
	db "<LINE>", "with friends to"
	db "<CONT>", "get some more!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own130To139::
	db TX_START, "Outstanding!"
	db "<LINE>", "You've become a"
	db "<CONT>", "real pro at this!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own140To149::
	db TX_START, "I have nothing"
	db "<LINE>", "left to say!"
	db "<CONT>", "You're the"
	db "<CONT>", "authority now!"
	db "<DONE>"

;@ path: text/pokedex_ratings
_DexRatingText_Own150To151::
	db TX_START, "Your #DEX is"
	db "<LINE>", "entirely complete!"
	db "<CONT>", "Congratulations!"
	db "<DONE>"
;@ path: text/ViridianPokecenter
_ViridianPokecenterGentlemanText::
	db TX_START, "You can use that"
	db "<LINE>", "PC in the corner."

	db "<PARA>", "The receptionist"
	db "<LINE>", "told me. So kind!"
	db "<DONE>"

;@ path: text/ViridianPokecenter
_ViridianPokecenterCooltrainerMText::
	db TX_START, "There's a #MON"
	db "<LINE>", "CENTER in every"
	db "<CONT>", "town ahead."

	db "<PARA>", "They don't charge"
	db "<LINE>", "any money either!"
	db "<DONE>"
;@ path: text/ViridianMart
_ViridianMartClerkSayHiToOakText::
	db TX_START, "Okay! Say hi to"
	db "<LINE>", "PROF.OAK for me!"
	db "<DONE>"

;@ path: text/ViridianMart
_ViridianMartClerkYouCameFromPalletTownText::
	db TX_START, "Hey! You came from"
	db "<LINE>", "PALLET TOWN?"
	db "<DONE>"

;@ path: text/ViridianMart
_ViridianMartClerkParcelQuestText::
	db TX_START, "You know PROF."
	db "<LINE>", "OAK, right?"

	db "<PARA>", "His order came in."
	db "<LINE>", "Will you take it"
	db "<CONT>", "to him?"

	db "<PARA>", "<PLAYER> got"
	db "<LINE>", "OAK's PARCEL!@"
	db TX_END

;@ path: text/ViridianMart
_ViridianMartYoungsterText::
	db TX_START, "This shop sells"
	db "<LINE>", "many ANTIDOTEs."
	db "<DONE>"

;@ path: text/ViridianMart
_ViridianMartCooltrainerMText::
	db TX_START, "No! POTIONs are"
	db "<LINE>", "all sold out."
	db "<DONE>"
;@ path: text/ViridianSchoolHouse
_ViridianSchoolHouseBrunetteGirlText::
	db TX_START, "Whew! I'm trying"
	db "<LINE>", "to memorize all"
	db "<CONT>", "my notes."
	db "<DONE>"

;@ path: text/ViridianSchoolHouse
_ViridianSchoolHouseCooltrainerFText::
	db TX_START, "Okay!"

	db "<PARA>", "Be sure to read"
	db "<LINE>", "the blackboard"
	db "<CONT>", "carefully!"
	db "<DONE>"
;@ path: text/ViridianNicknameHouse
_ViridianNicknameHouseBaldingGuyText::
	db TX_START, "Coming up with"
	db "<LINE>", "nicknames is fun,"
	db "<CONT>", "but hard."

	db "<PARA>", "Simple names are"
	db "<LINE>", "the easiest to"
	db "<CONT>", "remember."
	db "<DONE>"

;@ path: text/ViridianNicknameHouse
_ViridianNicknameHouseLittleGirlText::
	db TX_START, "My Daddy loves"
	db "<LINE>", "#MON too."
	db "<DONE>"

;@ path: text/ViridianNicknameHouse
_ViridianNicknameHouseSpearowText::
	db TX_START, "SPEARY: Tetweet!"
	db "<DONE>"

;@ path: text/ViridianNicknameHouse
_ViridianNicknameHouseSpearySignText::
	db TX_START, "SPEAROW"
	db "<LINE>", "Name: SPEARY"
	db "<DONE>"
;@ path: text/ViridianGym
_ViridianGymGiovanniPreBattleText::
	db TX_START, "Fwahahaha! This is"
	db "<LINE>", "my hideout!"

	db "<PARA>", "I planned to"
	db "<LINE>", "resurrect TEAM"
	db "<CONT>", "ROCKET here!"

	db "<PARA>", "But, you have"
	db "<LINE>", "caught me again!"
	db "<CONT>", "So be it! This"
	db "<CONT>", "time, I'm not"
	db "<CONT>", "holding back!"

	db "<PARA>", "Once more, you"
	db "<LINE>", "shall face"
	db "<CONT>", "GIOVANNI, the"
	db "<CONT>", "greatest trainer!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymGiovanniReceivedEarthBadgeText::
	db TX_START, "Ha!"
	db "<LINE>", "That was a truly"
	db "<CONT>", "intense fight!"
	db "<CONT>", "You have won!"
	db "<CONT>", "As proof, here is"
	db "<CONT>", "the EARTHBADGE!@"
	db TX_END

;@ path: text/ViridianGym
_ViridianGymGiovanniPostBattleAdviceText::
	db TX_START, "Having lost, I"
	db "<LINE>", "cannot face my"
	db "<CONT>", "underlings!"
	db "<CONT>", "TEAM ROCKET is"
	db "<CONT>", "finished forever!"

	db "<PARA>", "I will dedicate my"
	db "<LINE>", "life to the study"
	db "<CONT>", "of #MON!"

	db "<PARA>", "Let us meet again"
	db "<LINE>", "some day!"
	db "<CONT>", "Farewell!@"
	db TX_END

;@ path: text/ViridianGym
_ViridianGymGiovanniEarthBadgeInfoText::
	db TX_START, "The EARTHBADGE"
	db "<LINE>", "makes #MON of"
	db "<CONT>", "any level obey!"

	db "<PARA>", "It is evidence of"
	db "<LINE>", "your mastery as a"
	db "<CONT>", "#MON trainer!"

	db "<PARA>", "With it, you can"
	db "<LINE>", "enter the #MON"
	db "<CONT>", "LEAGUE!"

	db "<PARA>", "It is my gift for"
	db "<LINE>", "your #MON"
	db "<CONT>", "LEAGUE challenge!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymGiovanniReceivedTM27Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM27!@"
	db TX_END

;@ path: text/ViridianGym
_ViridianGymGiovanniTM27ExplanationText::
	db TX_START

	db "<PARA>", "TM27 is FISSURE!"
	db "<LINE>", "It will take out"
	db "<CONT>", "#MON with just"
	db "<CONT>", "one hit!"

	db "<PARA>", "I made it when I"
	db "<LINE>", "ran the GYM here,"
	db "<CONT>", "too long ago..."
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymGiovanniTM27NoRoomText::
	db TX_START, "You do not have"
	db "<LINE>", "space for this!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM1BattleText::
	db TX_START, "Heh! You must be"
	db "<LINE>", "running out of"
	db "<CONT>", "steam by now!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM1EndBattleText::
	db TX_START, "I"
	db "<LINE>", "ran out of gas!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM1AfterBattleText::
	db TX_START, "You need power to"
	db "<LINE>", "keep up with our"
	db "<CONT>", "GYM LEADER!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymHiker1BattleText::
	db TX_START, "Rrrroar! I'm"
	db "<LINE>", "working myself"
	db "<CONT>", "into a rage!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymHiker1EndBattleText::
	db TX_START, "Wargh!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymHiker1AfterBattleText::
	db TX_START, "I'm still not"
	db "<LINE>", "worthy!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymRocker1BattleText::
	db TX_START, "#MON and I, we"
	db "<LINE>", "make wonderful"
	db "<CONT>", "music together!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymRocker1EndBattleText::
	db TX_START, "You are in"
	db "<LINE>", "perfect harmony!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymRocker1AfterBattleText::
	db TX_START, "Do you know the"
	db "<LINE>", "identity of our"
	db "<CONT>", "GYM LEADER?"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymHiker2BattleText::
	db TX_START, "Karate is the"
	db "<LINE>", "ultimate form of"
	db "<CONT>", "martial arts!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymHiker2EndBattleText::
	db TX_START, "Atcho!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymHiker2AfterBattleText::
	db TX_START, "If my #MON"
	db "<LINE>", "were as good at"
	db "<CONT>", "Karate as I..."
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM2BattleText::
	db TX_START, "The truly talented"
	db "<LINE>", "win with style!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM2EndBattleText::
	db TX_START, "I"
	db "<LINE>", "lost my grip!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM2AfterBattleText::
	db TX_START, "The LEADER will"
	db "<LINE>", "scold me!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymHiker3BattleText::
	db TX_START, "I'm the KARATE"
	db "<LINE>", "KING! Your fate"
	db "<CONT>", "rests with me!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymHiker3EndBattleText::
	db TX_START, "Ayah!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymHiker3AfterBattleText::
	db TX_START, "#MON LEAGUE?"
	db "<LINE>", "You? Don't get"
	db "<CONT>", "cocky!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymRocker2BattleText::
	db TX_START, "Your #MON will"
	db "<LINE>", "cower at the"
	db "<CONT>", "crack of my whip!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymRocker2EndBattleText::
	db TX_START, "Yowch!"
	db "<LINE>", "Whiplash!"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymRocker2AfterBattleText::
	db TX_START, "Wait! I was just"
	db "<LINE>", "careless!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM3BattleText::
	db TX_START, "VIRIDIAN GYM was"
	db "<LINE>", "closed for a long"
	db "<CONT>", "time, but now our"
	db "<CONT>", "LEADER is back!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM3EndBattleText::
	db TX_START, "I"
	db "<LINE>", "was beaten?"
	db "<PROMPT>"

;@ path: text/ViridianGym
_ViridianGymCooltrainerM3AfterBattleText::
	db TX_START, "You can go onto"
	db "<LINE>", "#MON LEAGUE"
	db "<CONT>", "only by defeating"
	db "<CONT>", "our GYM LEADER!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymGuidePreBattleText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "Even I don't know"
	db "<LINE>", "VIRIDIAN LEADER's"
	db "<CONT>", "identity!"

	db "<PARA>", "This will be the"
	db "<LINE>", "toughest of all"
	db "<CONT>", "the GYM LEADERs!"

	db "<PARA>", "I heard that the"
	db "<LINE>", "trainers here"
	db "<CONT>", "like ground-type"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/ViridianGym
_ViridianGymGuidePostBattleText::
	db TX_START, "Blow me away!"
	db "<LINE>", "GIOVANNI was the"
	db "<CONT>", "GYM LEADER here?"
	db "<DONE>"
;@ path: text/Museum1F
_Museum1FScientist1ComeAgainText::
	db TX_START, "Come again!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1WouldYouLikeToComeInText::
	db TX_START, "It's ¥50 for a"
	db "<LINE>", "child's ticket."

	db "<PARA>", "Would you like to"
	db "<LINE>", "come in?"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1ThankYouText::
	db TX_START, "Right, ¥50!"
	db "<LINE>", "Thank you!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1DontHaveEnoughMoneyText::
	db TX_START, "You don't have"
	db "<LINE>", "enough money."
	db "<PROMPT>"

;@ path: text/Museum1F
_Museum1FScientist1DoYouKnowWhatAmberIsText::
	db TX_START, "You can't sneak"
	db "<LINE>", "in the back way!"

	db "<PARA>", "Oh, whatever!"
	db "<LINE>", "Do you know what"
	db "<CONT>", "AMBER is?"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1TheresALabSomewhereText::
	db TX_START, "There's a lab"
	db "<LINE>", "somewhere trying"
	db "<CONT>", "to resurrect"
	db "<CONT>", "ancient #MON"
	db "<CONT>", "from AMBER."
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1AmberIsFossilizedTreeSapText::
	db TX_START, "AMBER is fossil-"
	db "<LINE>", "ized tree sap."
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1GoToOtherSideText::
	db TX_START, "Please go to the"
	db "<LINE>", "other side!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist1TakePlentyOfTimeText::
	db TX_START, "Take plenty of"
	db "<LINE>", "time to look!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FGamblerText::
	db TX_START, "That is one"
	db "<LINE>", "magnificent"
	db "<CONT>", "fossil!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist2TakeThisToAPokemonLabText::
	db TX_START, "Ssh! I think that"
	db "<LINE>", "this chunk of"
	db "<CONT>", "AMBER contains"
	db "<CONT>", "#MON DNA!"

	db "<PARA>", "It would be great"
	db "<LINE>", "if #MON could"
	db "<CONT>", "be resurrected"
	db "<CONT>", "from it!"

	db "<PARA>", "But, my colleagues"
	db "<LINE>", "just ignore me!"

	db "<PARA>", "So I have a favor"
	db "<LINE>", "to ask!"

	db "<PARA>", "Take this to a"
	db "<LINE>", "#MON LAB and"
	db "<CONT>", "get it examined!"
	db "<PROMPT>"

;@ path: text/Museum1F
_Museum1FScientist2ReceivedOldAmberText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "OLD AMBER!@"
	db TX_END

;@ path: text/Museum1F
_Museum1FScientist2GetTheOldAmberCheckText::
	db TX_START, "Ssh! Get the OLD"
	db "<LINE>", "AMBER checked!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist2YouDontHaveSpaceText::
	db TX_START, "You don't have"
	db "<LINE>", "space for this!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FScientist3Text::
	db TX_START, "We are proud of 2"
	db "<LINE>", "fossils of very"
	db "<CONT>", "rare, prehistoric"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/Museum1F
_Museum1FOldAmberText::
	db TX_START, "The AMBER is"
	db "<LINE>", "clear and gold!"
	db "<DONE>"
;@ path: text/Museum2F
_Museum2FYoungsterText::
	db TX_START, "MOON STONE?"

	db "<PARA>", "What's so special"
	db "<LINE>", "about it?"
	db "<DONE>"

;@ path: text/Museum2F
_Museum2FGrampsText::
	db TX_START, "July 20, 1969!"

	db "<PARA>", "The 1st lunar"
	db "<LINE>", "landing!"

	db "<PARA>", "I bought a color"
	db "<LINE>", "TV to watch it!"
	db "<DONE>"

;@ path: text/Museum2F
_Museum2FScientistText::
	db TX_START, "We have a space"
	db "<LINE>", "exhibit now."
	db "<DONE>"

;@ path: text/Museum2F
_Museum2FBrunetteGirlText::
	db TX_START, "I want a PIKACHU!"
	db "<LINE>", "It's so cute!"

	db "<PARA>", "I asked my Daddy"
	db "<LINE>", "to catch me one!"
	db "<DONE>"

;@ path: text/Museum2F
_Museum2FHikerText::
	db TX_START, "Yeah, a PIKACHU"
	db "<LINE>", "soon, I promise!"
	db "<DONE>"

;@ path: text/Museum2F
_Museum2FSpaceShuttleSignText::
	db TX_START, "SPACE SHUTTLE"
	db "<LINE>", "COLUMBIA"
	db "<DONE>"

;@ path: text/Museum2F
_Museum2FMoonStoneSignText::
	db TX_START, "Meteorite that"
	db "<LINE>", "fell on MT.MOON."
	db "<CONT>", "(MOON STONE?)"
	db "<DONE>"
;@ path: text/PewterGym
_PewterGymBrockPreBattleText::
	db TX_START, "I'm BROCK!"
	db "<LINE>", "I'm PEWTER's GYM"
	db "<CONT>", "LEADER!"

	db "<PARA>", "I believe in rock"
	db "<LINE>", "hard defense and"
	db "<CONT>", "determination!"

	db "<PARA>", "That's why my"
	db "<LINE>", "#MON are all"
	db "<CONT>", "the rock-type!"

	db "<PARA>", "Do you still want"
	db "<LINE>", "to challenge me?"
	db "<CONT>", "Fine then! Show"
	db "<CONT>", "me your best!"
	db "<DONE>"


SECTION "Text 7", ROMX

;@ path: text/PewterGym_2
_PewterGymBrockPostBattleAdviceText::
	db TX_START, "There are all"
	db "<LINE>", "kinds of trainers"
	db "<CONT>", "in the world!"

	db "<PARA>", "You appear to be"
	db "<LINE>", "very gifted as a"
	db "<CONT>", "#MON trainer!"

	db "<PARA>", "Go to the GYM in"
	db "<LINE>", "CERULEAN and test"
	db "<CONT>", "your abilities!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymBrockWaitTakeThisText::
	db TX_START, "Wait! Take this"
	db "<LINE>", "with you!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymReceivedTM34Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM34!@"
	db TX_END

;@ path: text/PewterGym_2
_TM34ExplanationText::
	db TX_START

	db "<PARA>", "A TM contains a"
	db "<LINE>", "technique that"
	db "<CONT>", "can be taught to"
	db "<CONT>", "#MON!"

	db "<PARA>", "A TM is good only"
	db "<LINE>", "once! So when you"
	db "<CONT>", "use one to teach"
	db "<CONT>", "a new technique,"
	db "<CONT>", "pick the #MON"
	db "<CONT>", "carefully!"

	db "<PARA>", "TM34 contains"
	db "<LINE>", "BIDE!"

	db "<PARA>", "Your #MON will"
	db "<LINE>", "absorb damage in"
	db "<CONT>", "battle then pay"
	db "<CONT>", "it back double!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymTM34NoRoomText::
	db TX_START, "You don't have"
	db "<LINE>", "room for this!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymBrockReceivedBoulderBadgeText::
	db TX_START, "I took"
	db "<LINE>", "you for granted."

	db "<PARA>", "As proof of your"
	db "<LINE>", "victory, here's"
	db "<CONT>", "the BOULDERBADGE!"

	db "<PARA>", "<PLAYER> received"
	db "<LINE>", "the BOULDERBADGE!@"
	db TX_END

;@ path: text/PewterGym_2
_PewterGymBrockBoulderBadgeInfoText::
	db TX_START

	db "<PARA>", "That's an official"
	db "<LINE>", "#MON LEAGUE"
	db "<CONT>", "BADGE!"

	db "<PARA>", "Its bearer's"
	db "<LINE>", "#MON become"
	db "<CONT>", "more powerful!"

	db "<PARA>", "The technique"
	db "<LINE>", "FLASH can now be"
	db "<CONT>", "used any time!"
	db "<PROMPT>"

;@ path: text/PewterGym_2
_PewterGymCooltrainerMBattleText::
	db TX_START, "Stop right there,"
	db "<LINE>", "kid!"

	db "<PARA>", "You're still light"
	db "<LINE>", "years from facing"
	db "<CONT>", "BROCK!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymCooltrainerMEndBattleText::
	db TX_START, "Darn!"

	db "<PARA>", "Light years isn't"
	db "<LINE>", "time! It measures"
	db "<CONT>", "distance!"
	db "<PROMPT>"

;@ path: text/PewterGym_2
_PewterGymCooltrainerMAfterBattleText::
	db TX_START, "You're pretty hot,"
	db "<LINE>", "but not as hot"
	db "<CONT>", "as BROCK!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymGuidePreAdviceText::
	db TX_START, "Hiya! I can tell"
	db "<LINE>", "you have what it"
	db "<CONT>", "takes to become a"
	db "<CONT>", "#MON champ!"

	db "<PARA>", "I'm no trainer,"
	db "<LINE>", "but I can tell"
	db "<CONT>", "you how to win!"

	db "<PARA>", "Let me take you"
	db "<LINE>", "to the top!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymGuideBeginAdviceText::
	db TX_START, "All right! Let's"
	db "<LINE>", "get happening!"
	db "<PROMPT>"

;@ path: text/PewterGym_2
_PewterGymGuideAdviceText::
	db TX_START, "The 1st #MON"
	db "<LINE>", "out in a match is"
	db "<CONT>", "at the top of the"
	db "<CONT>", "#MON LIST!"

	db "<PARA>", "By changing the"
	db "<LINE>", "order of #MON,"
	db "<CONT>", "matches could be"
	db "<CONT>", "made easier!"
	db "<DONE>"

;@ path: text/PewterGym_2
_PewterGymGuideFreeServiceText::
	db TX_START, "It's a free"
	db "<LINE>", "service! Let's"
	db "<CONT>", "get happening!"
	db "<PROMPT>"

;@ path: text/PewterGym_2
_PewterGymGuidePostBattleText::
	db TX_START, "Just as I thought!"
	db "<LINE>", "You're #MON"
	db "<CONT>", "champ material!"
	db "<DONE>"
;@ path: text/PewterNidoranHouse
_PewterNidoranHouseNidoranText::
	db TX_START, "NIDORAN: Bowbow!@"
	db TX_END

;@ path: text/PewterNidoranHouse
_PewterNidoranHouseLittleBoyText::
	db TX_START, "NIDORAN sit!"
	db "<DONE>"

;@ path: text/PewterNidoranHouse
_PewterNidoranHouseMiddleAgedManText::
	db TX_START, "Our #MON's an"
	db "<LINE>", "outsider, so it's"
	db "<CONT>", "hard to handle."

	db "<PARA>", "An outsider is a"
	db "<LINE>", "#MON that you"
	db "<CONT>", "get in a trade."

	db "<PARA>", "It grows fast, but"
	db "<LINE>", "it may ignore an"
	db "<CONT>", "unskilled trainer"
	db "<CONT>", "in battle!"

	db "<PARA>", "If only we had"
	db "<LINE>", "some BADGEs..."
	db "<DONE>"
;@ path: text/PewterMart
_PewterMartYoungsterText::
	db TX_START, "A shady, old man"
	db "<LINE>", "got me to buy"
	db "<CONT>", "this really weird"
	db "<CONT>", "fish #MON!"

	db "<PARA>", "It's totally weak"
	db "<LINE>", "and it cost ¥500!"
	db "<DONE>"

;@ path: text/PewterMart
_PewterMartSuperNerdText::
	db TX_START, "Good things can"
	db "<LINE>", "happen if you"
	db "<CONT>", "raise #MON"
	db "<CONT>", "diligently, even"
	db "<CONT>", "the weak ones!"
	db "<DONE>"
;@ path: text/PewterSpeechHouse
_PewterSpeechHouseGamblerText::
	db TX_START, "#MON learn new"
	db "<LINE>", "techniques as"
	db "<CONT>", "they grow!"

	db "<PARA>", "But, some moves"
	db "<LINE>", "must be taught by"
	db "<CONT>", "the trainer!"
	db "<DONE>"

;@ path: text/PewterSpeechHouse
_PewterSpeechHouseYoungsterText::
	db TX_START, "#MON become"
	db "<LINE>", "easier to catch"
	db "<CONT>", "when they are"
	db "<CONT>", "hurt or asleep!"

	db "<PARA>", "But, it's not a"
	db "<LINE>", "sure thing!"
	db "<DONE>"
;@ path: text/PewterPokecenter
_PewterPokecenterGentlemanText::
	db TX_START, "What!?"

	db "<PARA>", "TEAM ROCKET is"
	db "<LINE>", "at MT.MOON? Huh?"
	db "<CONT>", "I'm on the phone!"

	db "<PARA>", "Scram!"
	db "<DONE>"

;@ path: text/PewterPokecenter
_PewterPokecenterJigglypuffText::
	db TX_START, "JIGGLYPUFF: Puu"
	db "<LINE>", "pupuu!"
	db "<DONE>"
;@ path: text/CeruleanTrashedHouse
_CeruleanTrashedHouseFishingGuruTheyStoleATMText::
	db TX_START, "Those miserable"
	db "<LINE>", "ROCKETs!"

	db "<PARA>", "Look what they"
	db "<LINE>", "did here!"

	db "<PARA>", "They stole a TM"
	db "<LINE>", "for teaching"
	db "<CONT>", "#MON how to"
	db "<CONT>", "DIG holes!"

	db "<PARA>", "That cost me a"
	db "<LINE>", "bundle, it did!"
	db "<DONE>"

;@ path: text/CeruleanTrashedHouse
_CeruleanTrashedHouseFishingGuruWhatsLostIsLostText::
	db TX_START, "I figure what's"
	db "<LINE>", "lost is lost!"

	db "<PARA>", "I decided to teach"
	db "<LINE>", "DIGLETT how to"
	db "<CONT>", "DIG without a TM!"
	db "<DONE>"

;@ path: text/CeruleanTrashedHouse
_CeruleanTrashedHouseGirlText::
	db TX_START, "TEAM ROCKET must"
	db "<LINE>", "be trying to DIG"
	db "<CONT>", "their way into no"
	db "<CONT>", "good!"
	db "<DONE>"

;@ path: text/CeruleanTrashedHouse
_CeruleanTrashedHouseWallHoleText::
	db TX_START, "TEAM ROCKET left"
	db "<LINE>", "a way out!"
	db "<DONE>"
;@ path: text/CeruleanTradeHouse
_CeruleanTradeHouseGrannyText::
	db TX_START, "My husband likes"
	db "<LINE>", "trading #MON."

	db "<PARA>", "If you are a"
	db "<LINE>", "collector, would"
	db "<CONT>", "you please trade"
	db "<CONT>", "with him?"
	db "<DONE>"
;@ path: text/CeruleanPokecenter
_CeruleanPokecenterSuperNerdText::
	db TX_START, "That BILL!"

	db "<PARA>", "I heard that"
	db "<LINE>", "he'll do whatever"
	db "<CONT>", "it takes to get"
	db "<CONT>", "rare #MON!"
	db "<DONE>"

;@ path: text/CeruleanPokecenter
_CeruleanPokecenterGentlemanText::
	db TX_START, "Have you heard"
	db "<LINE>", "about BILL?"

	db "<PARA>", "Everyone calls"
	db "<LINE>", "him a #MANIAC!"

	db "<PARA>", "I think people"
	db "<LINE>", "are just jealous"
	db "<CONT>", "of BILL, though."

	db "<PARA>", "Who wouldn't want"
	db "<LINE>", "to boast about"
	db "<CONT>", "their #MON?"
	db "<DONE>"
;@ path: text/CeruleanGym
_CeruleanGymMistyPreBattleText::
	db TX_START, "Hi, you're a new"
	db "<LINE>", "face!"

	db "<PARA>", "Trainers who want"
	db "<LINE>", "to turn pro have"
	db "<CONT>", "to have a policy"
	db "<CONT>", "about #MON!"

	db "<PARA>", "What is your"
	db "<LINE>", "approach when you"
	db "<CONT>", "catch #MON?"

	db "<PARA>", "My policy is an"
	db "<LINE>", "all-out offensive"
	db "<CONT>", "with water-type"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymMistyTM11ExplanationText::
	db TX_START, "TM11 teaches"
	db "<LINE>", "BUBBLEBEAM!"

	db "<PARA>", "Use it on an"
	db "<LINE>", "aquatic #MON!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymMistyCascadeBadgeInfoText::
	db TX_START, "The CASCADEBADGE"
	db "<LINE>", "makes all #MON"
	db "<CONT>", "up to L30 obey!"

	db "<PARA>", "That includes"
	db "<LINE>", "even outsiders!"

	db "<PARA>", "There's more, you"
	db "<LINE>", "can now use CUT"
	db "<CONT>", "any time!"

	db "<PARA>", "You can CUT down"
	db "<LINE>", "small bushes to"
	db "<CONT>", "open new paths!"

	db "<PARA>", "You can also have"
	db "<LINE>", "my favorite TM!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymMistyReceivedTM11Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM11!@"
	db TX_END

;@ path: text/CeruleanGym
_CeruleanGymMistyTM11NoRoomText::
	db TX_START, "You better make"
	db "<LINE>", "room for this!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymMistyReceivedCascadeBadgeText::
	db TX_START, "Wow!"
	db "<LINE>", "You're too much!"

	db "<PARA>", "All right!"

	db "<PARA>", "You can have the"
	db "<LINE>", "CASCADEBADGE to"
	db "<CONT>", "show you beat me!@"
	db TX_END

;@ path: text/CeruleanGym
_CeruleanGymBattleText1::
	db TX_START, "I'm more than good"
	db "<LINE>", "enough for you!"

	db "<PARA>", "MISTY can wait!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymEndBattleText1::
	db TX_START, "You"
	db "<LINE>", "overwhelmed me!"
	db "<PROMPT>"

;@ path: text/CeruleanGym
_CeruleanGymAfterBattleText1::
	db TX_START, "You have to face"
	db "<LINE>", "other trainers to"
	db "<CONT>", "find out how good"
	db "<CONT>", "you really are."
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymBattleText2::
	db TX_START, "Splash!"

	db "<PARA>", "I'm first up!"
	db "<LINE>", "Let's do it!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymEndBattleText2::
	db TX_START, "That"
	db "<LINE>", "can't be!"
	db "<PROMPT>"

;@ path: text/CeruleanGym
_CeruleanGymAfterBattleText2::
	db TX_START, "MISTY is going to"
	db "<LINE>", "keep improving!"

	db "<PARA>", "She won't lose to"
	db "<LINE>", "someone like you!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymGymGuideChampInMakingText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "Here's my advice!"

	db "<PARA>", "The LEADER, MISTY,"
	db "<LINE>", "is a pro who uses"
	db "<CONT>", "water #MON!"

	db "<PARA>", "You can drain all"
	db "<LINE>", "their water with"
	db "<CONT>", "plant #MON!"

	db "<PARA>", "Or, zap them with"
	db "<LINE>", "electricity!"
	db "<DONE>"

;@ path: text/CeruleanGym
_CeruleanGymGymGuideBeatMistyText::
	db TX_START, "You beat MISTY!"
	db "<LINE>", "What'd I tell ya?"

	db "<PARA>", "You and me kid,"
	db "<LINE>", "we make a pretty"
	db "<CONT>", "darn good team!"
	db "<DONE>"
;@ path: text/BikeShop
_BikeShopClerkWelcomeText::
	db TX_START, "Hi! Welcome to"
	db "<LINE>", "our BIKE SHOP."

	db "<PARA>", "Have we got just"
	db "<LINE>", "the BIKE for you!"
	db "<PROMPT>"

;@ path: text/BikeShop
_BikeShopClerkDoYouLikeItText::
	db TX_START, "It's a cool BIKE!"
	db "<LINE>", "Do you want it?"
	db "<DONE>"

;@ path: text/BikeShop
_BikeShopCantAffordText::
	db TX_START, "Sorry! You can't"
	db "<LINE>", "afford it!"
	db "<PROMPT>"

;@ path: text/BikeShop
_BikeShopClerkOhThatsAVoucherText::
	db TX_START, "Oh, that's..."

	db "<PARA>", "A BIKE VOUCHER!"

	db "<PARA>", "OK! Here you go!"
	db "<PROMPT>"

;@ path: text/BikeShop
_BikeShopExchangedVoucherText::
	db TX_START, "<PLAYER> exchanged"
	db "<LINE>", "the BIKE VOUCHER"
	db "<CONT>", "for a BICYCLE.@"
	db TX_END

;@ path: text/BikeShop
_BikeShopComeAgainText::
	db TX_START, "Come back again"
	db "<LINE>", "some time!"
	db "<DONE>"

;@ path: text/BikeShop
_BikeShopClerkHowDoYouLikeYourBicycleText::
	db TX_START, "How do you like"
	db "<LINE>", "your new BICYCLE?"

	db "<PARA>", "You can take it"
	db "<LINE>", "on CYCLING ROAD"
	db "<CONT>", "and in caves!"
	db "<DONE>"

;@ path: text/BikeShop
_BikeShopBagFullText::
	db TX_START, "You better make"
	db "<LINE>", "room for this!"
	db "<DONE>"

;@ path: text/BikeShop
_BikeShopMiddleAgedWomanText::
	db TX_START, "A plain city BIKE"
	db "<LINE>", "is good enough"
	db "<CONT>", "for me!"

	db "<PARA>", "You can't put a"
	db "<LINE>", "shopping basket"
	db "<CONT>", "on an MTB!"
	db "<DONE>"

;@ path: text/BikeShop
_BikeShopYoungsterTheseBikesAreExpensiveText::
	db TX_START, "These BIKEs are"
	db "<LINE>", "cool, but they're"
	db "<CONT>", "way expensive!"
	db "<DONE>"

;@ path: text/BikeShop
_BikeShopYoungsterCoolBikeText::
	db TX_START, "Wow. Your BIKE is"
	db "<LINE>", "really cool!"
	db "<DONE>"
;@ path: text/CeruleanMart
_CeruleanMartCooltrainerMText::
	db TX_START, "Use REPEL to keep"
	db "<LINE>", "bugs and weak"
	db "<CONT>", "#MON away."

	db "<PARA>", "Put your strongest"
	db "<LINE>", "#MON at the"
	db "<CONT>", "top of the list"
	db "<CONT>", "for best results!"
	db "<DONE>"

;@ path: text/CeruleanMart
_CeruleanMartCooltrainerFText::
	db TX_START, "Have you seen any"
	db "<LINE>", "RARE CANDY?"

	db "<PARA>", "It's supposed to"
	db "<LINE>", "make #MON go"
	db "<CONT>", "up one level!"
	db "<DONE>"
;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseMiddleAgedManText::
	db TX_START, "#MON BADGEs"
	db "<LINE>", "are owned only by"
	db "<CONT>", "skilled trainers."

	db "<PARA>", "I see you have"
	db "<LINE>", "at least one."

	db "<PARA>", "Those BADGEs have"
	db "<LINE>", "amazing secrets!"
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseMiddleAgedManWhichBadgeText::
	db TX_START, "Now then..."

	db "<PARA>", "Which of the 8"
	db "<LINE>", "BADGEs should I"
	db "<CONT>", "describe?"
	db "<DONE>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseMiddleAgedManVisitAnyTimeText::
	db TX_START, "Come visit me any"
	db "<LINE>", "time you wish."
	db "<DONE>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseBoulderBadgeText::
	db TX_START, "The ATTACK of all"
	db "<LINE>", "#MON increases"
	db "<CONT>", "a little bit."

	db "<PARA>", "It also lets you"
	db "<LINE>", "use FLASH any"
	db "<CONT>", "time you desire."
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseCascadeBadgeText::
	db TX_START, "#MON up to L30"
	db "<LINE>", "will obey you."

	db "<PARA>", "Any higher, they"
	db "<LINE>", "become unruly!"

	db "<PARA>", "It also lets you"
	db "<LINE>", "use CUT outside"
	db "<CONT>", "of battle."
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseThunderBadgeText::
	db TX_START, "The SPEED of all"
	db "<LINE>", "#MON increases"
	db "<CONT>", "a little bit."

	db "<PARA>", "It also lets you"
	db "<LINE>", "use FLY outside"
	db "<CONT>", "of battle."
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseRainbowBadgeText::
	db TX_START, "#MON up to L50"
	db "<LINE>", "will obey you."

	db "<PARA>", "Any higher, they"
	db "<LINE>", "become unruly!"

	db "<PARA>", "It also lets you"
	db "<LINE>", "use STRENGTH out-"
	db "<CONT>", "side of battle."
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseSoulBadgeText::
	db TX_START, "The DEFENSE of all"
	db "<LINE>", "#MON increases"
	db "<CONT>", "a little bit."

	db "<PARA>", "It also lets you"
	db "<LINE>", "use SURF outside"
	db "<CONT>", "of battle."
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseMarshBadgeText::
	db TX_START, "#MON up to L70"
	db "<LINE>", "will obey you."

	db "<PARA>", "Any higher, they"
	db "<LINE>", "become unruly!"
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseVolcanoBadgeText::
	db TX_START, "Your #MON's"
	db "<LINE>", "SPECIAL abilities"
	db "<CONT>", "increase a bit."
	db "<PROMPT>"

;@ path: text/CeruleanBadgeHouse
_CeruleanBadgeHouseEarthBadgeText::
	db TX_START, "All #MON will"
	db "<LINE>", "obey you!"
	db "<PROMPT>"
;@ path: text/LavenderPokecenter
_LavenderPokecenterGentlemanText::
	db TX_START, "TEAM ROCKET will"
	db "<LINE>", "do anything for"
	db "<CONT>", "the sake of gold!"
	db "<DONE>"

;@ path: text/LavenderPokecenter
_LavenderPokecenterLittleGirlText::
	db TX_START, "I saw CUBONE's"
	db "<LINE>", "mother die trying"
	db "<CONT>", "to escape from"
	db "<CONT>", "TEAM ROCKET!"
	db "<DONE>"
;@ path: text/PokemonTower1F
_PokemonTower1FReceptionistText::
	db TX_START, "#MON TOWER was"
	db "<LINE>", "erected in the"
	db "<CONT>", "memory of #MON"
	db "<CONT>", "that had died."
	db "<DONE>"

;@ path: text/PokemonTower1F
_PokemonTower1FMiddleAgedWomanText::
	db TX_START, "Did you come to"
	db "<LINE>", "pay respects?"
	db "<CONT>", "Bless you!"
	db "<DONE>"

;@ path: text/PokemonTower1F
_PokemonTower1FBaldingGuyText::
	db TX_START, "I came to pray"
	db "<LINE>", "for my CLEFAIRY."

	db "<PARA>", "Sniff! I can't"
	db "<LINE>", "stop crying..."
	db "<DONE>"

;@ path: text/PokemonTower1F
_PokemonTower1FGirlText::
	db TX_START, "My GROWLITHE..."
	db "<LINE>", "Why did you die?"
	db "<DONE>"

;@ path: text/PokemonTower1F
_PokemonTower1FChannelerText::
	db TX_START, "I am a CHANNELER!"
	db "<LINE>", "There are spirits"
	db "<CONT>", "up to mischief!"
	db "<DONE>"
;@ path: text/PokemonTower2F
_PokemonTower2FRivalWhatBringsYouHereText::
	db TX_START, "<RIVAL>: Hey,"
	db "<LINE>", "<PLAYER>! What"
	db "<CONT>", "brings you here?"
	db "<CONT>", "Your #MON"
	db "<CONT>", "don't look dead!"

	db "<PARA>", "I can at least"
	db "<LINE>", "make them faint!"
	db "<CONT>", "Let's go, pal!"
	db "<DONE>"

;@ path: text/PokemonTower2F
_PokemonTower2FRivalDefeatedText::
	db TX_START, "What?"
	db "<LINE>", "You stinker!"

	db "<PARA>", "I took it easy on"
	db "<LINE>", "you too!"
	db "<PROMPT>"

;@ path: text/PokemonTower2F
_PokemonTower2FRivalVictoryText::
	db TX_START, "<RIVAL>: Well,"
	db "<LINE>", "look at all your"
	db "<CONT>", "wimpy #MON!"

	db "<PARA>", "Toughen them up a"
	db "<LINE>", "bit more!"
	db "<PROMPT>"

;@ path: text/PokemonTower2F
_PokemonTower2FRivalHowsYourDexText::
	db TX_START, "How's your #DEX"
	db "<LINE>", "coming, pal?"
	db "<CONT>", "I just caught a"
	db "<CONT>", "CUBONE!"

	db "<PARA>", "I can't find the"
	db "<LINE>", "grown-up MAROWAK"
	db "<CONT>", "yet!"

	db "<PARA>", "I doubt there are"
	db "<LINE>", "any left! Well, I"
	db "<CONT>", "better get going!"
	db "<CONT>", "I've got a lot to"
	db "<CONT>", "accomplish, pal!"

	db "<PARA>", "Smell ya later!"
	db "<DONE>"

;@ path: text/PokemonTower2F
_PokemonTower2FChannelerText::
	db TX_START, "Even we could not"
	db "<LINE>", "identify the"
	db "<CONT>", "wayward GHOSTs!"

	db "<PARA>", "A SILPH SCOPE"
	db "<LINE>", "might be able to"
	db "<CONT>", "unmask them."
	db "<DONE>"
;@ path: text/PokemonTower3F
_PokemonTower3FChanneler1BattleText::
	db TX_START, "Urrg...Awaa..."
	db "<LINE>", "Huhu...graa.."
	db "<DONE>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler1EndBattleText::
	db TX_START, "Hwa!"
	db "<LINE>", "I'm saved!"
	db "<PROMPT>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler1AfterBattleText::
	db TX_START, "The GHOSTs can be"
	db "<LINE>", "identified by the"
	db "<CONT>", "SILPH SCOPE."
	db "<DONE>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler2BattleText::
	db TX_START, "Kekeke...."
	db "<LINE>", "Kwaaah!"
	db "<DONE>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler2EndBattleText::
	db TX_START, "Hmm?"
	db "<LINE>", "What am I doing?"
	db "<PROMPT>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler2AfterBattleText::
	db TX_START, "Sorry! I was"
	db "<LINE>", "possessed!"
	db "<DONE>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler3BattleText::
	db TX_START, "Be gone!"
	db "<LINE>", "Evil spirit!"
	db "<DONE>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler3EndBattleText::
	db TX_START, "Whew!"
	db "<LINE>", "The spirit left!"
	db "<PROMPT>"

;@ path: text/PokemonTower3F
_PokemonTower3FChanneler3AfterBattleText::
	db TX_START, "My friends were"
	db "<LINE>", "possessed too!"
	db "<DONE>"
;@ path: text/PokemonTower4F
_PokemonTower4FChanneler1BattleText::
	db TX_START, "GHOST! No!"
	db "<LINE>", "Kwaaah!"
	db "<DONE>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler1EndBattleText::
	db TX_START, "Where"
	db "<LINE>", "is the GHOST?"
	db "<PROMPT>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler1AfterBattleText::
	db TX_START, "I must have been"
	db "<LINE>", "dreaming..."
	db "<DONE>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler2BattleText::
	db TX_START, "Be cursed with"
	db "<LINE>", "me! Kwaaah!"
	db "<DONE>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler2EndBattleText::
	db TX_START, "What!"
	db "<PROMPT>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler2AfterBattleText::
	db TX_START, "We can't crack"
	db "<LINE>", "the identity of"
	db "<CONT>", "the GHOSTs."
	db "<DONE>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler3BattleText::
	db TX_START, "Huhuhu..."
	db "<LINE>", "Beat me not!"
	db "<DONE>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler3EndBattleText::
	db TX_START, "Huh?"
	db "<LINE>", "Who? What?"
	db "<PROMPT>"

;@ path: text/PokemonTower4F
_PokemonTower4FChanneler3AfterBattleText::
	db TX_START, "May the departed"
	db "<LINE>", "souls of #MON"
	db "<CONT>", "rest in peace..."
	db "<DONE>"
;@ path: text/PokemonTower5F
_PokemonTower5FChanneler1Text::
	db TX_START, "Come, child! I"
	db "<LINE>", "sealed this space"
	db "<CONT>", "with white magic!"

	db "<PARA>", "You can rest here!"
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler2BattleText::
	db TX_START, "Give...me..."
	db "<LINE>", "your...soul..."
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler2EndBattleText::
	db TX_START, "Gasp!"
	db "<PROMPT>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler2AfterBattleText::
	db TX_START, "I was under"
	db "<LINE>", "possession!"
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler3BattleText::
	db TX_START, "You...shall..."
	db "<LINE>", "join...us..."
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler3EndBattleText::
	db TX_START, "What"
	db "<LINE>", "a nightmare!"
	db "<PROMPT>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler3AfterBattleText::
	db TX_START, "I was possessed!"
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler4BattleText::
	db TX_START, "Zombies!"
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler4EndBattleText::
	db TX_START, "Ha?"
	db "<PROMPT>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler4AfterBattleText::
	db TX_START, "I regained my"
	db "<LINE>", "senses!"
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler5BattleText::
	db TX_START, "Urgah..."
	db "<LINE>", "Urff...."
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler5EndBattleText::
	db TX_START, "Whoo!"
	db "<PROMPT>"

;@ path: text/PokemonTower5F
_PokemonTower5FChanneler5AfterBattleText::
	db TX_START, "I fell to evil"
	db "<LINE>", "spirits despite"
	db "<CONT>", "my training!"
	db "<DONE>"

;@ path: text/PokemonTower5F
_PokemonTower5FPurifiedZoneText::
	db TX_START, "Entered purified,"
	db "<LINE>", "protected zone!"

	db "<PARA>", "<PLAYER>'s #MON"
	db "<LINE>", "are fully healed!"
	db "<DONE>"
;@ path: text/PokemonTower6F
_PokemonTower6FGhostWasCubonesMotherText::
	db TX_START, "The GHOST was the"
	db "<LINE>", "restless soul of"
	db "<CONT>", "CUBONE's mother!"
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FSoulWasCalmedText::
	db TX_START, "The mother's soul"
	db "<LINE>", "was calmed."

	db "<PARA>", "It departed to"
	db "<LINE>", "the afterlife!"
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler1BattleText::
	db TX_START, "Give...me..."
	db "<LINE>", "blood..."
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler1EndBattleText::
	db TX_START, "Groan!"
	db "<PROMPT>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler1AfterBattleText::
	db TX_START, "I feel anemic and"
	db "<LINE>", "weak..."
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler2BattleText::
	db TX_START, "Urff... Kwaah!"
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler2EndBattleText::
	db TX_START, "Some-"
	db "<LINE>", "thing fell out!"
	db "<PROMPT>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler2AfterBattleText::
	db TX_START, "Hair didn't fall"
	db "<LINE>", "out! It was an"
	db "<CONT>", "evil spirit!"
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler3BattleText::
	db TX_START, "Ke..ke...ke..."
	db "<LINE>", "ke..ke...ke!!"
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler3EndBattleText::
	db TX_START, "Keee!"
	db "<PROMPT>"

;@ path: text/PokemonTower6F
_PokemonTower6FChanneler3AfterBattleText::
	db TX_START, "What's going on"
	db "<LINE>", "here?"
	db "<DONE>"

;@ path: text/PokemonTower6F
_PokemonTower6FBeGoneText::
	db TX_START, "Be gone..."
	db "<LINE>", "Intruders..."
	db "<DONE>"
;@ path: text/PokemonTower7F
_PokemonTower7FMrFujiRescueText::
	db TX_START, "MR.FUJI: Heh? You"
	db "<LINE>", "came to save me?"

	db "<PARA>", "Thank you. But, I"
	db "<LINE>", "came here of my"
	db "<CONT>", "own free will."

	db "<PARA>", "I came to calm"
	db "<LINE>", "the soul of"
	db "<CONT>", "CUBONE's mother."

	db "<PARA>", "I think MAROWAK's"
	db "<LINE>", "spirit has gone"
	db "<CONT>", "to the afterlife."

	db "<PARA>", "I must thank you"
	db "<LINE>", "for your kind"
	db "<CONT>", "concern!"

	db "<PARA>", "Follow me to my"
	db "<LINE>", "home, #MON"
	db "<CONT>", "HOUSE at the foot"
	db "<CONT>", "of this tower."
	db "<DONE>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket1BattleText::
	db TX_START, "What do you want?"
	db "<LINE>", "Why are you here?"
	db "<DONE>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket1EndBattleText::
	db TX_START, "I give up!"
	db "<PROMPT>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket1AfterBattleText::
	db TX_START, "I'm not going to"
	db "<LINE>", "forget this!"
	db "<DONE>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket2BattleText::
	db TX_START, "This old guy came"
	db "<LINE>", "and complained"
	db "<CONT>", "about us harming"
	db "<CONT>", "useless #MON!"

	db "<PARA>", "We're talking it"
	db "<LINE>", "over as adults!"
	db "<DONE>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket2EndBattleText::
	db TX_START, "Please!"
	db "<LINE>", "No more!"
	db "<PROMPT>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket2AfterBattleText::
	db TX_START, "#MON are only"
	db "<LINE>", "good for making"
	db "<CONT>", "money!"

	db "<PARA>", "Stay out of our"
	db "<LINE>", "business!"
	db "<DONE>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket3BattleText::
	db TX_START, "You're not saving"
	db "<LINE>", "anyone, kid!"
	db "<DONE>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket3EndBattleText::
	db TX_START, "Don't"
	db "<LINE>", "fight us ROCKETs!"
	db "<PROMPT>"

;@ path: text/PokemonTower7F
_PokemonTower7FRocket3AfterBattleText::
	db TX_START, "You're not getting"
	db "<LINE>", "away with this!"
	db "<DONE>"
;@ path: text/MrFujisHouse
_MrFujisHouseSuperNerdMrFujiIsntHereText::
	db TX_START, "That's odd, MR.FUJI"
	db "<LINE>", "isn't here."
	db "<CONT>", "Where'd he go?"
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHouseSuperNerdMrFujiHadBeenPrayingText::
	db TX_START, "MR.FUJI had been"
	db "<LINE>", "praying alone for"
	db "<CONT>", "CUBONE's mother."
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHouseLittleGirlThisIsMrFujisHouseText::
	db TX_START, "This is really"
	db "<LINE>", "MR.FUJI's house."

	db "<PARA>", "He's really kind!"

	db "<PARA>", "He looks after"
	db "<LINE>", "abandoned and"
	db "<CONT>", "orphaned #MON!"
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHouseLittleGirlPokemonAreNiceToHugText::
	db TX_START, "It's so warm!"
	db "<LINE>", "#MON are so"
	db "<CONT>", "nice to hug!"
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHousePsyduckText::
	db TX_START, "PSYDUCK: Gwappa!@"
	db TX_END

;@ path: text/MrFujisHouse
_MrFujisHouseNidorinoText::
	db TX_START, "NIDORINO: Gaoo!@"
	db TX_END

;@ path: text/MrFujisHouse
_MrFujisHouseMrFujiIThinkThisMayHelpYourQuestText::
	db TX_START, "MR.FUJI: <PLAYER>."

	db "<PARA>", "Your #DEX quest"
	db "<LINE>", "may fail without"
	db "<CONT>", "love for your"
	db "<CONT>", "#MON."

	db "<PARA>", "I think this may"
	db "<LINE>", "help your quest."
	db "<PROMPT>"

;@ path: text/MrFujisHouse
_MrFujisHouseMrFujiReceivedPokeFluteText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/MrFujisHouse
_MrFujisHouseMrFujiPokeFluteExplanationText::
	db TX_START

	db "<PARA>", "Upon hearing #"
	db "<LINE>", "FLUTE, sleeping"
	db "<CONT>", "#MON will"
	db "<CONT>", "spring awake."

	db "<PARA>", "It works on all"
	db "<LINE>", "sleeping #MON."
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHouseMrFujiPokeFluteNoRoomText::
	db TX_START, "You must make"
	db "<LINE>", "room for this!"
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHouseMrFujiHasMyFluteHelpedYouText::
	db TX_START, "MR.FUJI: Has my"
	db "<LINE>", "FLUTE helped you?"
	db "<DONE>"

;@ path: text/MrFujisHouse
_MrFujisHouseMrFujiPokedexText::
	db TX_START, "#MON Monthly"
	db "<LINE>", "Grand Prize"
	db "<CONT>", "Drawing!"

	db "<PARA>", "The application"
	db "<LINE>", "form is..."

	db "<PARA>", "Gone! It's been"
	db "<LINE>", "clipped out!"
	db "<DONE>"
;@ path: text/LavenderMart
_LavenderMartBaldingGuyText::
	db TX_START, "I'm searching for"
	db "<LINE>", "items that raise"
	db "<CONT>", "the abilities of"
	db "<CONT>", "#MON during a"
	db "<CONT>", "single battle."

	db "<PARA>", "X ATTACK, X"
	db "<LINE>", "DEFEND, X SPEED"
	db "<CONT>", "and X SPECIAL are"
	db "<CONT>", "what I'm after."

	db "<PARA>", "Do you know where"
	db "<LINE>", "I can get them?"
	db "<DONE>"

;@ path: text/LavenderMart
_LavenderMartCooltrainerMReviveText::
	db TX_START, "You know REVIVE?"
	db "<LINE>", "It revives any"
	db "<CONT>", "fainted #MON!"
	db "<DONE>"

;@ path: text/LavenderMart
_LavenderMartCooltrainerMNuggetText::
	db TX_START, "I found a NUGGET"
	db "<LINE>", "in the mountains."

	db "<PARA>", "I thought it was"
	db "<LINE>", "useless, but it"
	db "<CONT>", "sold for ¥5000!"
	db "<DONE>"
;@ path: text/LavenderCuboneHouse
_LavenderCuboneHouseCuboneText::
	db TX_START, "CUBONE: Kyarugoo!@"
	db TX_END

;@ path: text/LavenderCuboneHouse
_LavenderCuboneHouseBrunetteGirlPoorCubonesMotherText::
	db TX_START, "I hate those"
	db "<LINE>", "horrible ROCKETs!"

	db "<PARA>", "That poor CUBONE's"
	db "<LINE>", "mother..."

	db "<PARA>", "It was killed"
	db "<LINE>", "trying to escape"
	db "<CONT>", "from TEAM ROCKET!"
	db "<DONE>"

;@ path: text/LavenderCuboneHouse
_LavenderCuboneHouseBrunetteGirlGhostIsGoneText::
	db TX_START, "The GHOST of"
	db "<LINE>", "#MON TOWER is"
	db "<CONT>", "gone!"

	db "<PARA>", "Someone must have"
	db "<LINE>", "soothed its"
	db "<CONT>", "restless soul!"
	db "<DONE>"
;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterWantMeToRateText::
	db TX_START, "Hello, hello!"
	db "<LINE>", "I am the official"
	db "<CONT>", "NAME RATER!"

	db "<PARA>", "Want me to rate"
	db "<LINE>", "the nicknames of"
	db "<CONT>", "your #MON?"
	db "<DONE>"

;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterWhichPokemonText::
	db TX_START, "Which #MON"
	db "<LINE>", "should I look at?"
	db "<PROMPT>"

;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterGiveItANiceNameText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, ", is it?"
	db "<LINE>", "That is a decent"
	db "<CONT>", "nickname!"

	db "<PARA>", "But, would you"
	db "<LINE>", "like me to give"
	db "<CONT>", "it a nicer name?"

	db "<PARA>", "How about it?"
	db "<DONE>"

;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterWhatShouldWeNameItText::
	db TX_START, "Fine! What should"
	db "<LINE>", "we name it?"
	db "<PROMPT>"

;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterPokemonHasBeenRenamedText::
	db TX_START, "OK! This #MON"
	db "<LINE>", "has been renamed"
	db "<CONT>", "@"
	db TX_RAM
	dw wBuffer
	db TX_START, "!"

	db "<PARA>", "That's a better"
	db "<LINE>", "name than before!"
	db "<DONE>"

;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterComeAnyTimeYouLikeText::
	db TX_START, "Fine! Come any"
	db "<LINE>", "time you like!"
	db "<DONE>"

;@ path: text/NameRatersHouse
_NameRatersHouseNameRaterATrulyImpeccableNameText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, ", is it?"
	db "<LINE>", "That is a truly"
	db "<CONT>", "impeccable name!"

	db "<PARA>", "Take good care of"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"
	db "<DONE>"
;@ path: text/VermilionPokecenter
_VermilionPokecenterFishingGuruText::
	db TX_START, "Even if they are"
	db "<LINE>", "the same level,"
	db "<CONT>", "#MON can have"
	db "<CONT>", "very different"
	db "<CONT>", "abilities."

	db "<PARA>", "A #MON raised"
	db "<LINE>", "by a trainer is"
	db "<CONT>", "stronger than one"
	db "<CONT>", "in the wild."
	db "<DONE>"

;@ path: text/VermilionPokecenter
_VermilionPokecenterSailorText::
	db TX_START, "My #MON was"
	db "<LINE>", "poisoned! It"
	db "<CONT>", "fainted while we"
	db "<CONT>", "were walking!"
	db "<DONE>"
;@ path: text/PokemonFanClub
_PokemonFanClubPikachuFanNormalText::
	db TX_START, "Won't you admire"
	db "<LINE>", "my PIKACHU's"
	db "<CONT>", "adorable tail?"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubPikachuFanBetterText::
	db TX_START, "Humph! My PIKACHU"
	db "<LINE>", "is twice as cute"
	db "<CONT>", "as that one!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubSeelFanNormalText::
	db TX_START, "I just love my"
	db "<LINE>", "SEEL!"

	db "<PARA>", "It squeals when I"
	db "<LINE>", "hug it!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubSeelFanBetterText::
	db TX_START, "Oh dear!"

	db "<PARA>", "My SEEL is far"
	db "<LINE>", "more attractive!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubPikachuText::
	db TX_START, "PIKACHU: Chu!"
	db "<LINE>", "Pikachu!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubSeelText::
	db TX_START, "SEEL: Kyuoo!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubChairmanIntroText::
	db TX_START, "I chair the"
	db "<LINE>", "#MON Fan Club!"

	db "<PARA>", "I have collected"
	db "<LINE>", "over 100 #MON!"

	db "<PARA>", "I'm very fussy"
	db "<LINE>", "when it comes to"
	db "<CONT>", "#MON!"

	db "<PARA>", "So..."

	db "<PARA>", "Did you come"
	db "<LINE>", "visit to hear"
	db "<CONT>", "about my #MON?"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubChairmanStoryText::
	db TX_START, "Good!"
	db "<LINE>", "Then listen up!"

	db "<PARA>", "My favorite"
	db "<LINE>", "RAPIDASH..."

	db "<PARA>", "It...cute..."
	db "<LINE>", "lovely...smart..."
	db "<CONT>", "plus...amazing..."
	db "<CONT>", "you think so?..."
	db "<CONT>", "oh yes...it..."
	db "<CONT>", "stunning..."
	db "<CONT>", "kindly..."
	db "<CONT>", "love it!"

	db "<PARA>", "Hug it...when..."
	db "<CONT>", "sleeping...warm"
	db "<CONT>", "and cuddly..."
	db "<CONT>", "spectacular..."
	db "<CONT>", "ravishing..."
	db "<CONT>", "...Oops! Look at"
	db "<CONT>", "the time! I kept"
	db "<CONT>", "you too long!"

	db "<PARA>", "Thanks for hearing"
	db "<LINE>", "me out! I want"
	db "<CONT>", "you to have this!"
	db "<PROMPT>"

;@ path: text/PokemonFanClub
_PokemonFanClubReceivedBikeVoucherText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/PokemonFanClub
_PokemonFanClubExplainBikeVoucherText::
	db TX_START

	db "<PARA>", "Exchange that for"
	db "<LINE>", "a BICYCLE!"

	db "<PARA>", "Don't worry, my"
	db "<LINE>", "FEAROW will FLY"
	db "<CONT>", "me anywhere!"

	db "<PARA>", "So, I don't need a"
	db "<LINE>", "BICYCLE!"

	db "<PARA>", "I hope you like"
	db "<LINE>", "cycling!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubNoStoryText::
	db TX_START, "Oh. Come back"
	db "<LINE>", "when you want to"
	db "<CONT>", "hear my story!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubChairFinalText::
	db TX_START, "Hello, <PLAYER>!"

	db "<PARA>", "Did you come see"
	db "<LINE>", "me about my"
	db "<CONT>", "#MON again?"

	db "<PARA>", "No? Too bad!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubBagFullText::
	db TX_START, "Make room for"
	db "<LINE>", "this!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubReceptionistText::
	db TX_START, "Our Chairman is"
	db "<LINE>", "very vocal about"
	db "<CONT>", "#MON."
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubSign1Text::
	db TX_START, "Let's all listen"
	db "<LINE>", "politely to other"
	db "<CONT>", "trainers!"
	db "<DONE>"

;@ path: text/PokemonFanClub
_PokemonFanClubSign2Text::
	db TX_START, "If someone brags,"
	db "<LINE>", "brag right back!"
	db "<DONE>"
;@ path: text/VermilionMart
_VermilionMartCooltrainerMText::
	db TX_START, "There are evil"
	db "<LINE>", "people who will"
	db "<CONT>", "use #MON for"
	db "<CONT>", "criminal acts."

	db "<PARA>", "TEAM ROCKET"
	db "<LINE>", "traffics in rare"
	db "<CONT>", "#MON."

	db "<PARA>", "They also abandon"
	db "<LINE>", "#MON that they"
	db "<CONT>", "consider not to"
	db "<CONT>", "be popular or"
	db "<CONT>", "useful."
	db "<DONE>"

;@ path: text/VermilionMart
_VermilionMartCooltrainerFText::
	db TX_START, "I think #MON"
	db "<LINE>", "can be good or"
	db "<CONT>", "evil. It depends"
	db "<CONT>", "on the trainer."
	db "<DONE>"
;@ path: text/VermilionGym
_VermilionGymLTSurgePreBattleText::
	db TX_START, "Hey, kid! What do"
	db "<LINE>", "you think you're"
	db "<CONT>", "doing here?"

	db "<PARA>", "You won't live"
	db "<LINE>", "long in combat!"
	db "<CONT>", "That's for sure!"

	db "<PARA>", "I tell you kid,"
	db "<LINE>", "electric #MON"
	db "<CONT>", "saved me during"
	db "<CONT>", "the war!"

	db "<PARA>", "They zapped my"
	db "<LINE>", "enemies into"
	db "<CONT>", "paralysis!"

	db "<PARA>", "The same as I'll"
	db "<LINE>", "do to you!"
	db "<DONE>"


SECTION "Text 8", ROMX

;@ path: text/VermilionGym_2
_VermilionGymLTSurgePostBattleAdviceText::
	db TX_START, "A little word of"
	db "<LINE>", "advice, kid!"

	db "<PARA>", "Electricity is"
	db "<LINE>", "sure powerful!"

	db "<PARA>", "But, it's useless"
	db "<LINE>", "against ground-"
	db "<CONT>", "type #MON!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymLTSurgeThunderBadgeInfoText::
	db TX_START, "The THUNDERBADGE"
	db "<LINE>", "cranks up your"
	db "<CONT>", "#MON's SPEED!"

	db "<PARA>", "It also lets your"
	db "<LINE>", "#MON FLY any"
	db "<CONT>", "time, kid!"

	db "<PARA>", "You're special,"
	db "<LINE>", "kid! Take this!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymLTSurgeReceivedTM24Text::
	db TX_START, "<PLAYER> received "
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/VermilionGym_2
_TM24ExplanationText::
	db TX_START

	db "<PARA>", "TM24 contains"
	db "<LINE>", "THUNDERBOLT!"

	db "<PARA>", "Teach it to an"
	db "<LINE>", "electric #MON!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymLTSurgeTM24NoRoomText::
	db TX_START, "Yo kid, make room"
	db "<LINE>", "in your pack!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymLTSurgeReceivedThunderBadgeText::
	db TX_START, "Whoa!"

	db "<PARA>", "You're the real"
	db "<LINE>", "deal, kid!"

	db "<PARA>", "Fine then, take"
	db "<LINE>", "the THUNDERBADGE!"
	db "<PROMPT>"

;@ path: text/VermilionGym_2
_VermilionGymGentlemanBattleText::
	db TX_START, "When I was in the"
	db "<LINE>", "Army, LT.SURGE"
	db "<CONT>", "was my strict CO!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymGentlemanEndBattleText::
	db TX_START, "Stop!"
	db "<LINE>", "You're very good!"
	db "<PROMPT>"

;@ path: text/VermilionGym_2
_VermilionGymGentlemanAfterBattleText::
	db TX_START, "The door won't"
	db "<LINE>", "open?"

	db "<PARA>", "LT.SURGE always"
	db "<LINE>", "was cautious!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymSuperNerdBattleText::
	db TX_START, "I'm a lightweight,"
	db "<LINE>", "but I'm good with"
	db "<CONT>", "electricity!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymSuperNerdEndBattleText::
	db TX_START, "Fried!"
	db "<PROMPT>"

;@ path: text/VermilionGym_2
_VermilionGymSuperNerdAfterBattleText::
	db TX_START, "OK, I'll talk!"

	db "<PARA>", "LT.SURGE said he"
	db "<LINE>", "hid door switches"
	db "<CONT>", "inside something!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymSailorBattleText::
	db TX_START, "This is no place"
	db "<LINE>", "for kids!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymSailorEndBattleText::
	db TX_START, "Wow!"
	db "<LINE>", "Surprised me!"
	db "<PROMPT>"

;@ path: text/VermilionGym_2
_VermilionGymSailorAfterBattleText::
	db TX_START, "LT.SURGE set up"
	db "<LINE>", "double locks!"
	db "<CONT>", "Here's a hint!"

	db "<PARA>", "When you open the"
	db "<LINE>", "1st lock, the 2nd"
	db "<CONT>", "lock is right"
	db "<CONT>", "next to it!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymGymGuideChampInMakingText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "LT.SURGE has a"
	db "<LINE>", "nickname. People"
	db "<CONT>", "refer to him as"
	db "<CONT>", "the Lightning"
	db "<CONT>", "American!"

	db "<PARA>", "He's an expert on"
	db "<LINE>", "electric #MON!"

	db "<PARA>", "Birds and water"
	db "<LINE>", "#MON are at"
	db "<CONT>", "risk! Beware of"
	db "<CONT>", "paralysis too!"

	db "<PARA>", "LT.SURGE is very"
	db "<LINE>", "cautious!"

	db "<PARA>", "You'll have to"
	db "<LINE>", "break a code to"
	db "<CONT>", "get to him!"
	db "<DONE>"

;@ path: text/VermilionGym_2
_VermilionGymGymGuideBeatLTSurgeText::
	db TX_START, "Whew! That match"
	db "<LINE>", "was electric!"
	db "<DONE>"
;@ path: text/VermilionPidgeyHouse
_VermilionPidgeyHouseYoungsterText::
	db TX_START, "I'm getting my"
	db "<LINE>", "PIDGEY to fly a"
	db "<CONT>", "letter to SAFFRON"
	db "<CONT>", "in the north!"
	db "<DONE>"

;@ path: text/VermilionPidgeyHouse
_VermilionPidgeyHousePidgeyText::
	db TX_START, "PIDGEY: Kurukkoo!@"
	db TX_END

;@ path: text/VermilionPidgeyHouse
_VermilionPidgeyHouseLetterText::
	db TX_START, "Dear PIPPI, I hope"
	db "<LINE>", "to see you soon."

	db "<PARA>", "I heard SAFFRON"
	db "<LINE>", "has problems with"
	db "<CONT>", "TEAM ROCKET."

	db "<PARA>", "VERMILION appears"
	db "<LINE>", "to be safe."
	db "<DONE>"
;@ path: text/VermilionDock
_VermilionDockUnusedText::
	db TX_START
	db "<DONE>"
;@ path: text/VermilionOldRodHouse
_VermilionOldRodHouseFishingGuruDoYouLikeToFishText::
	db TX_START, "I'm the FISHING"
	db "<LINE>", "GURU!"

	db "<PARA>", "I simply Looove"
	db "<LINE>", "fishing!"

	db "<PARA>", "Do you like to"
	db "<LINE>", "fish?"
	db "<DONE>"

;@ path: text/VermilionOldRodHouse
_VermilionOldRodHouseFishingGuruTakeThisText::
	db TX_START, "Grand! I like"
	db "<LINE>", "your style!"

	db "<PARA>", "Take this and"
	db "<LINE>", "fish, young one!"

	db "<PARA>", "<PLAYER> received"
	db "<LINE>", "an @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/VermilionOldRodHouse
_VermilionOldRodHouseFishingGuruFishingIsAWayOfLifeText::
	db TX_START

	db "<PARA>", "Fishing is a way"
	db "<LINE>", "of life!"

	db "<PARA>", "From the seas to"
	db "<LINE>", "rivers, go out"
	db "<CONT>", "and land the big"
	db "<CONT>", "one, young one!"
	db "<DONE>"

;@ path: text/VermilionOldRodHouse
_VermilionOldRodHouseFishingGuruThatsSoDisappointingText::
	db TX_START, "Oh... That's so"
	db "<LINE>", "disappointing..."
	db "<DONE>"

;@ path: text/VermilionOldRodHouse
_VermilionOldRodHouseFishingGuruHowAreTheFishBitingText::
	db TX_START, "Hello there,"
	db "<LINE>", "<PLAYER>!"

	db "<PARA>", "How are the fish"
	db "<LINE>", "biting?"
	db "<DONE>"

;@ path: text/VermilionOldRodHouse
_VermilionOldRodHouseFishingGuruNoRoomText::
	db TX_START, "Oh no!"

	db "<PARA>", "You have no room"
	db "<LINE>", "for my gift!"
	db "<DONE>"
;@ path: text/CeladonMart1F
_CeladonMart1FReceptionistText::
	db TX_START, "Hello! Welcome to"
	db "<LINE>", "CELADON DEPT."
	db "<CONT>", "STORE."

	db "<PARA>", "The board on the"
	db "<LINE>", "right describes"
	db "<CONT>", "the store layout."
	db "<DONE>"

;@ path: text/CeladonMart1F
_CeladonMart1FDirectorySignText::
	db TX_START, "1F: SERVICE"
	db "<LINE>", "    COUNTER"

	db "<PARA>", "2F: TRAINER'S"
	db "<LINE>", "    MARKET"

	db "<PARA>", "3F: TV GAME SHOP"

	db "<PARA>", "4F: WISEMAN GIFTS"

	db "<PARA>", "5F: DRUG STORE"

	db "<PARA>", "ROOFTOP SQUARE:"
	db "<LINE>", "VENDING MACHINES"
	db "<DONE>"

;@ path: text/CeladonMart1F
_CeladonMart1FCurrentFloorSignText::
	db TX_START, "1F: SERVICE"
	db "<LINE>", "    COUNTER"
	db "<DONE>"
;@ path: text/CeladonMart2F
_CeladonMart2FMiddleAgedManText::
	db TX_START, "SUPER REPEL keeps"
	db "<LINE>", "weak #MON at"
	db "<CONT>", "bay..."

	db "<PARA>", "Hmm, it's a more"
	db "<LINE>", "powerful REPEL!"
	db "<DONE>"

;@ path: text/CeladonMart2F
_CeladonMart2FGirlText::
	db TX_START, "For long outings,"
	db "<LINE>", "you should buy"
	db "<CONT>", "REVIVE."
	db "<DONE>"

;@ path: text/CeladonMart2F
_CeladonMart2FCurrentFloorSignText::
	db TX_START, "Top Grade Items"
	db "<LINE>", "for Trainers!"

	db "<PARA>", "2F: TRAINER'S"
	db "<LINE>", "    MARKET"
	db "<DONE>"
;@ path: text/CeladonMart3F
_CeladonMart3FClerkTM18PreReceiveText::
	db TX_START, "Oh, hi! I finally"
	db "<LINE>", "finished #MON!"

	db "<PARA>", "Not done yet?"
	db "<LINE>", "This might be"
	db "<CONT>", "useful!"
	db "<PROMPT>"

;@ path: text/CeladonMart3F
_CeladonMart3FClerkReceivedTM18Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CeladonMart3F
_CeladonMart3FClerkTM18ExplanationText::
	db TX_START, "TM18 is COUNTER!"
	db "<LINE>", "Not like the one"
	db "<CONT>", "I'm leaning on,"
	db "<CONT>", "mind you!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FClerkTM18NoRoomText::
	db TX_START, "Your pack is full"
	db "<LINE>", "of items!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FGameBoyKid1Text::
	db TX_START, "Captured #MON"
	db "<LINE>", "are registered"
	db "<CONT>", "with an ID No."
	db "<CONT>", "and OT, the name"
	db "<CONT>", "of the Original"
	db "<CONT>", "Trainer that"
	db "<CONT>", "caught it!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FGameBoyKid2Text::
	db TX_START, "All right!"

	db "<PARA>", "My buddy's going"
	db "<LINE>", "to trade me his"
	db "<CONT>", "KANGASKHAN for my"
	db "<CONT>", "GRAVELER!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FGameBoyKid3Text::
	db TX_START, "Come on GRAVELER!"

	db "<PARA>", "I love GRAVELER!"
	db "<LINE>", "I collect them!"

	db "<PARA>", "Huh?"

	db "<PARA>", "GRAVELER turned"
	db "<LINE>", "into a different"
	db "<CONT>", "#MON!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FLittleBoyText::
	db TX_START, "You can identify"
	db "<LINE>", "#MON you got"
	db "<CONT>", "in trades by"
	db "<CONT>", "their ID Numbers!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FSNESText::
	db TX_START, "It's an SNES!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FRPGText::
	db TX_START, "An RPG! There's"
	db "<LINE>", "no time for that!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FSportsGameText::
	db TX_START, "A sports game!"
	db "<LINE>", "Dad'll like that!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FPuzzleGameText::
	db TX_START, "A puzzle game!"
	db "<LINE>", "Looks addictive!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FFightingGameText::
	db TX_START, "A fighting game!"
	db "<LINE>", "Looks tough!"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FCurrentFloorSignText::
	db TX_START, "3F: TV GAME SHOP"
	db "<DONE>"

;@ path: text/CeladonMart3F
_CeladonMart3FPokemonPosterText::
	db TX_START, "Red and Blue!"
	db "<LINE>", "Both are #MON!"
	db "<DONE>"
;@ path: text/CeladonMart4F
_CeladonMart4FSuperNerdText::
	db TX_START, "I'm getting a"
	db "<LINE>", "# DOLL for my"
	db "<CONT>", "girl friend!"
	db "<DONE>"

;@ path: text/CeladonMart4F
_CeladonMart4FYoungsterText::
	db TX_START, "I heard something"
	db "<LINE>", "useful."

	db "<PARA>", "You can run from"
	db "<LINE>", "wild #MON by"
	db "<CONT>", "distracting them"
	db "<CONT>", "with a # DOLL!"
	db "<DONE>"

;@ path: text/CeladonMart4F
_CeladonMart4FCurrentFloorSignText::
	db TX_START, "Express yourself"
	db "<LINE>", "with gifts!"

	db "<PARA>", "4F: WISEMAN GIFTS"

	db "<PARA>", "Evolution Special!"
	db "<LINE>", "Element STONEs on"
	db "<CONT>", "sale now!"
	db "<DONE>"
;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlGiveHerWhichDrinkText::
	db TX_START, "Give her which"
	db "<LINE>", "drink?"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlYayFreshWaterText::
	db TX_START, "Yay!"

	db "<PARA>", "FRESH WATER!"

	db "<PARA>", "Thank you!"

	db "<PARA>", "You can have this"
	db "<LINE>", "from me!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlReceivedTM13Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlTM13ExplanationText::
	db TX_START

	db "<PARA>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, " contains"
	db "<LINE>", "ICE BEAM!"

	db "<PARA>", "It can freeze the"
	db "<LINE>", "target sometimes!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlYaySodaPopText::
	db TX_START, "Yay!"

	db "<PARA>", "SODA POP!"

	db "<PARA>", "Thank you!"

	db "<PARA>", "You can have this"
	db "<LINE>", "from me!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlReceivedTM48Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlTM48ExplanationText::
	db TX_START

	db "<PARA>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, " contains"
	db "<LINE>", "ROCK SLIDE!"

	db "<PARA>", "It can spook the"
	db "<LINE>", "target sometimes!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlYayLemonadeText::
	db TX_START, "Yay!"

	db "<PARA>", "LEMONADE!"

	db "<PARA>", "Thank you!"

	db "<PARA>", "You can have this"
	db "<LINE>", "from me!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlReceivedTM49Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM49!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlTM49ExplanationText::
	db TX_START

	db "<PARA>", "TM49 contains"
	db "<LINE>", "TRI ATTACK!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlNoRoomText::
	db TX_START, "You don't have"
	db "<LINE>", "space for this!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlImNotThirstyText::
	db TX_START, "No thank you!"
	db "<LINE>", "I'm not thirsty"
	db "<CONT>", "after all!@"
	db TX_END

;@ path: text/CeladonMartRoof
_CeladonMartRoofSuperNerdText::
	db TX_START, "My sister is a"
	db "<LINE>", "trainer, believe"
	db "<CONT>", "it or not."

	db "<PARA>", "But, she's so"
	db "<LINE>", "immature, she"
	db "<CONT>", "drives me nuts!"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlImThirstyText::
	db TX_START, "I'm thirsty!"
	db "<LINE>", "I want something"
	db "<CONT>", "to drink!"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_CeladonMartRoofLittleGirlGiveHerADrinkText::
	db TX_START, "I'm thirsty!"
	db "<LINE>", "I want something"
	db "<CONT>", "to drink!"

	db "<PARA>", "Give her a drink?"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_CeladonMartRoofCurrentFloorSignText::
	db TX_START, "ROOFTOP SQUARE:"
	db "<LINE>", "VENDING MACHINES"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_VendingMachineText1::
	db TX_START, "A vending machine!"
	db "<LINE>", "Here's the menu!"
	db "<PROMPT>"

;@ path: text/CeladonMartRoof
_VendingMachineText4::
	db TX_START, "Oops, not enough"
	db "<LINE>", "money!"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_VendingMachineText5::
	db TX_RAM
	dw wStringBuffer
	db TX_START
	db "<LINE>", "popped out!"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_VendingMachineText6::
	db TX_START, "There's no more"
	db "<LINE>", "room for stuff!"
	db "<DONE>"

;@ path: text/CeladonMartRoof
_VendingMachineText7::
	db TX_START, "Not thirsty!"
	db "<DONE>"
;@ path: text/CeladonMansion1F
_CeladonMansion1FMeowthText::
	db TX_START, "MEOWTH: Meow!@"
	db TX_END

;@ path: text/CeladonMansion1F
_CeladonMansion1FGrannyText::
	db TX_START, "My dear #MON"
	db "<LINE>", "keep me company."

	db "<PARA>", "MEOWTH even brings"
	db "<LINE>", "money home!"
	db "<DONE>"

;@ path: text/CeladonMansion1F
_CeladonMansion1FClefairyText::
	db TX_START, "CLEFAIRY: Pi"
	db "<LINE>", "pippippi!@"
	db TX_END

;@ path: text/CeladonMansion1F
_CeladonMansion1FNidoranFText::
	db TX_START, "NIDORAN: Kya"
	db "<LINE>", "kyaoo!@"
	db TX_END

;@ path: text/CeladonMansion1F
_CeladonMansion1FManagersSuiteSignText::
	db TX_START, "CELADON MANSION"
	db "<LINE>", "Manager's Suite"
	db "<DONE>"
;@ path: text/CeladonMansion2F
_CeladonMansion2FMeetingRoomSignText::
	db TX_START, "GAME FREAK"
	db "<LINE>", "Meeting Room"
	db "<DONE>"
;@ path: text/CeladonMansion3F
_CeladonMansion3FProgrammerText::
	db TX_START, "Me? I'm the"
	db "<LINE>", "programmer!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FGraphicArtistText::
	db TX_START, "I'm the graphic"
	db "<LINE>", "artist!"
	db "<CONT>", "I drew you!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FWriterText::
	db TX_START, "I wrote the story!"
	db "<LINE>", "Isn't ERIKA cute?"

	db "<PARA>", "I like MISTY a"
	db "<LINE>", "lot too!"

	db "<PARA>", "Oh, and SABRINA,"
	db "<LINE>", "I like her!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FGameDesignerText::
	db TX_START, "Is that right?"

	db "<PARA>", "I'm the game"
	db "<LINE>", "designer!"

	db "<PARA>", "Filling up your"
	db "<LINE>", "#DEX is tough,"
	db "<CONT>", "but don't quit!"

	db "<PARA>", "When you finish,"
	db "<LINE>", "come tell me!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FGameDesignerCompletedDexText::
	db TX_START, "Wow! Excellent!"
	db "<LINE>", "You completed"
	db "<CONT>", "your #DEX!"
	db "<CONT>", "Congratulations!"
	db "<CONT>", "...@"
	db TX_END

;@ path: text/CeladonMansion3F
_CeladonMansion3FGameProgramPCText::
	db TX_START, "It's the game"
	db "<LINE>", "program! Messing"
	db "<CONT>", "with it could bug"
	db "<CONT>", "out the game!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FPlayingGamePCText::
	db TX_START, "Someone's playing"
	db "<LINE>", "a game instead of"
	db "<CONT>", "working!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FGameScriptPCText::
	db TX_START, "It's the script!"
	db "<LINE>", "Better not look"
	db "<CONT>", "at the ending!"
	db "<DONE>"

;@ path: text/CeladonMansion3F
_CeladonMansion3FDevRoomSignText::
	db TX_START, "GAME FREAK"
	db "<LINE>", "Development Room"
	db "<DONE>"
;@ path: text/CeladonMansionRoof
_CeladonMansionRoofHouseSignText::
	db TX_START, "I KNOW EVERYTHING!"
	db "<DONE>"
;@ path: text/CeladonMansionRoofHouse
_CeladonMansionRoofHouseHikerText::
	db TX_START, "I know everything"
	db "<LINE>", "about the world"
	db "<CONT>", "of #MON in"
	db "<CONT>", "your GAME BOY!"

	db "<PARA>", "Get together with"
	db "<LINE>", "your friends and"
	db "<CONT>", "trade #MON!"
	db "<DONE>"
;@ path: text/CeladonPokecenter
_CeladonPokecenterGentlemanText::
	db TX_START, "# FLUTE awakens"
	db "<LINE>", "#MON with a"
	db "<CONT>", "sound that only"
	db "<CONT>", "they can hear!"
	db "<DONE>"

;@ path: text/CeladonPokecenter
_CeladonPokecenterBeautyText::
	db TX_START, "I rode uphill on"
	db "<LINE>", "CYCLING ROAD from"
	db "<CONT>", "FUCHSIA!"
	db "<DONE>"
;@ path: text/CeladonGym
_CeladonGymErikaPreBattleText::
	db TX_START, "Hello. Lovely"
	db "<LINE>", "weather isn't it?"
	db "<CONT>", "It's so pleasant."

	db "<PARA>", "...Oh dear..."
	db "<LINE>", "I must have dozed"
	db "<CONT>", "off. Welcome."

	db "<PARA>", "My name is ERIKA."
	db "<LINE>", "I am the LEADER"
	db "<CONT>", "of CELADON GYM."

	db "<PARA>", "I teach the art of"
	db "<LINE>", "flower arranging."
	db "<CONT>", "My #MON are of"
	db "<CONT>", "the grass-type."

	db "<PARA>", "Oh, I'm sorry, I"
	db "<LINE>", "had no idea that"
	db "<CONT>", "you wished to"
	db "<CONT>", "challenge me."

	db "<PARA>", "Very well, but I"
	db "<LINE>", "shall not lose."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymErikaReceivedRainbowBadgeText::
	db TX_START, "Oh!"
	db "<LINE>", "I concede defeat."

	db "<PARA>", "You are remarkably"
	db "<LINE>", "strong."

	db "<PARA>", "I must confer you"
	db "<LINE>", "the RAINBOWBADGE."
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymErikaPostBattleAdviceText::
	db TX_START, "You are cataloging"
	db "<LINE>", "#MON? I must"
	db "<CONT>", "say I'm impressed."

	db "<PARA>", "I would never"
	db "<LINE>", "collect #MON"
	db "<CONT>", "if they were"
	db "<CONT>", "unattractive."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymRainbowBadgeInfoText::
	db TX_START, "The RAINBOWBADGE"
	db "<LINE>", "will make #MON"
	db "<CONT>", "up to L50 obey."

	db "<PARA>", "It also allows"
	db "<LINE>", "#MON to use"
	db "<CONT>", "STRENGTH in and"
	db "<CONT>", "out of battle."

	db "<PARA>", "Please also take"
	db "<LINE>", "this with you."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymReceivedTM21Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CeladonGym
_TM21ExplanationText::
	db TX_START

	db "<PARA>", "TM21 contains"
	db "<LINE>", "MEGA DRAIN."

	db "<PARA>", "Half the damage"
	db "<LINE>", "it inflicts is"
	db "<CONT>", "drained to heal"
	db "<CONT>", "your #MON!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymTM21NoRoomText::
	db TX_START, "You should make"
	db "<LINE>", "room for this."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText2::
	db TX_START, "Hey!"

	db "<PARA>", "You are not"
	db "<LINE>", "allowed in here!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText2::
	db TX_START, "You're"
	db "<LINE>", "too rough!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText2::
	db TX_START, "Bleaah!"
	db "<LINE>", "I hope ERIKA"
	db "<CONT>", "wipes you out!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText3::
	db TX_START, "I was getting"
	db "<LINE>", "bored."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText3::
	db TX_START, "My"
	db "<LINE>", "makeup!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText3::
	db TX_START, "Grass-type #MON"
	db "<LINE>", "are tough against"
	db "<CONT>", "the water-type!"

	db "<PARA>", "They also have an"
	db "<LINE>", "edge on rock and"
	db "<CONT>", "ground #MON!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText4::
	db TX_START, "Aren't you the"
	db "<LINE>", "peeping Tom?"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText4::
	db TX_START, "I'm"
	db "<LINE>", "in shock!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText4::
	db TX_START, "Oh, you weren't"
	db "<LINE>", "peeping? We get a"
	db "<CONT>", "lot of gawkers!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText5::
	db TX_START, "Look at my grass"
	db "<LINE>", "#MON!"

	db "<PARA>", "They're so easy"
	db "<LINE>", "to raise!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText5::
	db TX_START, "No!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText5::
	db TX_START, "We only use grass-"
	db "<LINE>", "type #MON at"
	db "<CONT>", "our GYM!"

	db "<PARA>", "We also use them"
	db "<LINE>", "for making flower"
	db "<CONT>", "arrangements!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText6::
	db TX_START, "Don't bring any"
	db "<LINE>", "bugs or fire"
	db "<CONT>", "#MON in here!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText6::
	db TX_START, "Oh!"
	db "<LINE>", "You!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText6::
	db TX_START, "Our LEADER, ERIKA,"
	db "<LINE>", "might be quiet,"
	db "<CONT>", "but she's also"
	db "<CONT>", "very skilled!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText7::
	db TX_START, "Pleased to meet"
	db "<LINE>", "you. My hobby is"
	db "<CONT>", "#MON training."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText7::
	db TX_START, "Oh!"
	db "<LINE>", "Splendid!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText7::
	db TX_START, "I have a blind"
	db "<LINE>", "date coming up."
	db "<CONT>", "I have to learn"
	db "<CONT>", "to be polite."
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymBattleText8::
	db TX_START, "Welcome to"
	db "<LINE>", "CELADON GYM!"

	db "<PARA>", "You better not"
	db "<LINE>", "underestimate"
	db "<CONT>", "girl power!"
	db "<DONE>"

;@ path: text/CeladonGym
_CeladonGymEndBattleText8::
	db TX_START, "Oh!"
	db "<LINE>", "Beaten!"
	db "<PROMPT>"

;@ path: text/CeladonGym
_CeladonGymAfterBattleText8::
	db TX_START, "I didn't bring my"
	db "<LINE>", "best #MON!"

	db "<PARA>", "Wait 'til next"
	db "<LINE>", "time!"
	db "<DONE>"
;@ path: text/GameCorner
_GameCornerBeauty1Text::
	db TX_START, "Welcome!"

	db "<PARA>", "You can exchange"
	db "<LINE>", "your coins for"
	db "<CONT>", "fabulous prizes"
	db "<CONT>", "next door."
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk1DoYouNeedSomeGameCoinsText::
	db TX_START, "Welcome to ROCKET"
	db "<LINE>", "GAME CORNER!"

	db "<PARA>", "Do you need some"
	db "<LINE>", "game coins?"

	db "<PARA>", "It's ¥1000 for 50"
	db "<LINE>", "coins. Would you"
	db "<CONT>", "like some?"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk1ThanksHereAre50CoinsText::
	db TX_START, "Thanks! Here are"
	db "<LINE>", "your 50 coins!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk1PleaseComePlaySometimeText::
	db TX_START, "No? Please come"
	db "<LINE>", "play sometime!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk1CantAffordTheCoinsText::
	db TX_START, "You can't afford"
	db "<LINE>", "the coins!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk1CoinCaseIsFullText::
	db TX_START, "Oops! Your COIN"
	db "<LINE>", "CASE is full."
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk1DontHaveCoinCaseText::
	db TX_START, "You don't have a"
	db "<LINE>", "COIN CASE!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerMiddleAgedMan1Text::
	db TX_START, "Keep this quiet."

	db "<PARA>", "It's rumored that"
	db "<LINE>", "this place is run"
	db "<CONT>", "by TEAM ROCKET."
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerBeauty2Text::
	db TX_START, "I think these"
	db "<LINE>", "machines have"
	db "<CONT>", "different odds."
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerFishingGuruWantToPlayText::
	db TX_START, "Kid, do you want"
	db "<LINE>", "to play?"
	db "<PROMPT>"

;@ path: text/GameCorner
_GameCornerFishingGuruReceived10CoinsText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "10 coins!@"
	db TX_END

;@ path: text/GameCorner
_GameCornerFishingGuruDontNeedMyCoinsText::
	db TX_START, "You don't need my"
	db "<LINE>", "coins!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerFishingGuruWinsComeAndGoText::
	db TX_START, "Wins seem to come"
	db "<LINE>", "and go."
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerMiddleAgedWomanText::
	db TX_START, "I'm having a"
	db "<LINE>", "wonderful time!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerGymGuideChampInMakingText::
	db TX_START, "Hey!"

	db "<PARA>", "You have better"
	db "<LINE>", "things to do,"
	db "<CONT>", "champ in making!"

	db "<PARA>", "CELADON GYM's"
	db "<LINE>", "LEADER is ERIKA!"
	db "<CONT>", "She uses grass-"
	db "<CONT>", "type #MON!"

	db "<PARA>", "She might appear"
	db "<LINE>", "docile, but don't"
	db "<CONT>", "be fooled!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerGymGuideTheyOfferRarePokemonText::
	db TX_START, "They offer rare"
	db "<LINE>", "#MON that can"
	db "<CONT>", "be exchanged for"
	db "<CONT>", "your coins."

	db "<PARA>", "But, I just can't"
	db "<LINE>", "seem to win!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerGamblerText::
	db TX_START, "Games are scary!"
	db "<LINE>", "It's so easy to"
	db "<CONT>", "get hooked!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk2WantSomeCoinsText::
	db TX_START, "What's up? Want"
	db "<LINE>", "some coins?"
	db "<PROMPT>"

;@ path: text/GameCorner
_GameCornerClerk2Received20CoinsText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "20 coins!@"
	db TX_END

;@ path: text/GameCorner
_GameCornerClerk2YouHaveLotsOfCoinsText::
	db TX_START, "You have lots of"
	db "<LINE>", "coins!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerClerk2INeedMoreCoinsText::
	db TX_START, "Darn! I need more"
	db "<LINE>", "coins for the"
	db "<CONT>", "#MON I want!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerGentlemanThrowingMeOffText::
	db TX_START, "Hey, what? You're"
	db "<LINE>", "throwing me off!"
	db "<CONT>", "Here are some"
	db "<CONT>", "coins, shoo!"
	db "<PROMPT>"

;@ path: text/GameCorner
_GameCornerGentlemanReceived20CoinsText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "20 coins!@"
	db TX_END

;@ path: text/GameCorner
_GameCornerGentlemanYouGotYourOwnCoinsText::
	db TX_START, "You've got your"
	db "<LINE>", "own coins!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerGentlemanCloselyWatchTheReelsText::
	db TX_START, "The trick is to"
	db "<LINE>", "watch the reels"
	db "<CONT>", "closely!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerRocketImGuardingThisPosterText::
	db TX_START, "I'm guarding this"
	db "<LINE>", "poster!"
	db "<CONT>", "Go away, or else!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerRocketBattleEndText::
	db TX_START, "Dang!"
	db "<PROMPT>"

;@ path: text/GameCorner
_GameCornerRocketAfterBattleText::
	db TX_START, "Our hideout might"
	db "<LINE>", "be discovered! I"
	db "<CONT>", "better tell BOSS!"
	db "<DONE>"

;@ path: text/GameCorner
_GameCornerPosterSwitchBehindPosterText::
	db TX_START, "Hey!"

	db "<PARA>", "A switch behind"
	db "<LINE>", "the poster!?"
	db "<CONT>", "Let's push it!@"
	db TX_END

;@ path: text/GameCorner
_GameCornerOopsForgotCoinCaseText::
	db TX_START, "Oops! Forgot the"
	db "<LINE>", "COIN CASE!"
	db "<DONE>"
;@ path: text/CeladonMart5F
_CeladonMart5FGentlemanText::
	db TX_START, "#MON ability"
	db "<LINE>", "enhancers can be"
	db "<CONT>", "bought only here."

	db "<PARA>", "Use CALCIUM to"
	db "<LINE>", "increase SPECIAL"
	db "<CONT>", "abilities."

	db "<PARA>", "Use CARBOS to"
	db "<LINE>", "increase SPEED."
	db "<DONE>"

;@ path: text/CeladonMart5F
_CeladonMart5FSailorText::
	db TX_START, "I'm here for"
	db "<LINE>", "#MON ability"
	db "<CONT>", "enhancers."

	db "<PARA>", "PROTEIN increases"
	db "<LINE>", "ATTACK power."

	db "<PARA>", "IRON increases"
	db "<LINE>", "DEFENSE!"
	db "<DONE>"

;@ path: text/CeladonMart5F
_CeladonMart5FCurrentFloorSignText::
	db TX_START, "5F: DRUG STORE"
	db "<DONE>"
;@ path: text/GameCornerPrizeRoom
_GameCornerPrizeRoomBaldingGuyText::
	db TX_START, "I sure do fancy"
	db "<LINE>", "that PORYGON!"

	db "<PARA>", "But, it's hard to"
	db "<LINE>", "win at slots!"
	db "<DONE>"

;@ path: text/GameCornerPrizeRoom
_GameCornerPrizeRoomGamblerText::
	db TX_START, "I had a major"
	db "<LINE>", "haul today!"
	db "<DONE>"
;@ path: text/CeladonDiner
_CeladonDinerCookText::
	db TX_START, "Hi!"

	db "<PARA>", "We're taking a"
	db "<LINE>", "break now."
	db "<DONE>"

;@ path: text/CeladonDiner
_CeladonDinerMiddleAgedWomanText::
	db TX_START, "My #MON are"
	db "<LINE>", "weak, so I often"
	db "<CONT>", "have to go to the"
	db "<CONT>", "DRUG STORE."
	db "<DONE>"

;@ path: text/CeladonDiner
_CeladonDinerMiddleAgedManText::
	db TX_START, "Psst! There's a"
	db "<LINE>", "basement under"
	db "<CONT>", "the GAME CORNER."
	db "<DONE>"

;@ path: text/CeladonDiner
_CeladonDinerFisherText::
	db TX_START, "Munch..."

	db "<PARA>", "The man at that"
	db "<LINE>", "table lost it all"
	db "<CONT>", "at the slots."
	db "<DONE>"

;@ path: text/CeladonDiner
_CeladonDinerGymGuideImFlatOutBustedText::
	db TX_START, "Go ahead! Laugh!"

	db "<PARA>", "I'm flat out"
	db "<LINE>", "busted!"

	db "<PARA>", "No more slots for"
	db "<LINE>", "me! I'm going"
	db "<CONT>", "straight!"

	db "<PARA>", "Here! I won't be"
	db "<LINE>", "needing this any-"
	db "<CONT>", "more!"
	db "<PROMPT>"

;@ path: text/CeladonDiner
_CeladonDinerGymGuideReceivedCoinCaseText::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CeladonDiner
_CeladonDinerGymGuideCoinCaseNoRoomText::
	db TX_START, "Make room for"
	db "<LINE>", "this!"
	db "<DONE>"

;@ path: text/CeladonDiner
_CeladonDinerGymGuideWinItBackText::
	db TX_START, "I always thought"
	db "<LINE>", "I was going to"
	db "<CONT>", "win it back..."
	db "<DONE>"
;@ path: text/CeladonChiefHouse
_CeladonChiefHouseChiefText::
	db TX_START, "Hehehe! The slots"
	db "<LINE>", "just reel in the"
	db "<CONT>", "dough, big time!"
	db "<DONE>"

;@ path: text/CeladonChiefHouse
_CeladonChiefHouseRocketText::
	db TX_START, "CHIEF!"

	db "<PARA>", "We just shipped"
	db "<LINE>", "2000 #MON as"
	db "<CONT>", "slot prizes!"
	db "<DONE>"

;@ path: text/CeladonChiefHouse
_CeladonChiefHouseSailorText::
	db TX_START, "Don't touch the"
	db "<LINE>", "poster at the"
	db "<CONT>", "GAME CORNER!"

	db "<PARA>", "There's no secret"
	db "<LINE>", "switch behind it!"
	db "<DONE>"
;@ path: text/CeladonHotel
_CeladonHotelGrannyText::
	db TX_START, "#MON? No, this"
	db "<LINE>", "is a hotel for"
	db "<CONT>", "people."

	db "<PARA>", "We're full up."
	db "<DONE>"

;@ path: text/CeladonHotel
_CeladonHotelBeautyText::
	db TX_START, "I'm on vacation"
	db "<LINE>", "with my brother"
	db "<CONT>", "and boy friend."

	db "<PARA>", "CELADON is such a"
	db "<LINE>", "pretty city!"
	db "<DONE>"

;@ path: text/CeladonHotel
_CeladonHotelSuperNerdText::
	db TX_START, "Why did she bring"
	db "<LINE>", "her brother?"
	db "<DONE>"
;@ path: text/FuchsiaMart
_FuchsiaMartMiddleAgedManText::
	db TX_START, "Do you have a"
	db "<LINE>", "SAFARI ZONE flag?"

	db "<PARA>", "What about cards"
	db "<LINE>", "or calendars?"
	db "<DONE>"

;@ path: text/FuchsiaMart
_FuchsiaMartCooltrainerFText::
	db TX_START, "Did you try X"
	db "<LINE>", "SPEED? It speeds"
	db "<CONT>", "up a #MON in"
	db "<CONT>", "battle!"
	db "<DONE>"
;@ path: text/FuchsiaBillsGrandpasHouse
_FuchsiaBillsGrandpasHouseMiddleAgedWomanText::
	db TX_START, "SAFARI ZONE's"
	db "<LINE>", "WARDEN is old,"
	db "<CONT>", "but still active!"

	db "<PARA>", "All his teeth are"
	db "<LINE>", "false, though."
	db "<DONE>"

;@ path: text/FuchsiaBillsGrandpasHouse
_FuchsiaBillsGrandpasHouseBillsGrandpaText::
	db TX_START, "Hmm? You've met"
	db "<LINE>", "BILL?"

	db "<PARA>", "He's my grandson!"

	db "<PARA>", "He always liked"
	db "<LINE>", "collecting things"
	db "<CONT>", "even as a child!"
	db "<DONE>"

;@ path: text/FuchsiaBillsGrandpasHouse
_FuchsiaBillsGrandpasHouseYoungsterText::
	db TX_START, "BILL files his"
	db "<LINE>", "own #MON data"
	db "<CONT>", "on his PC!"

	db "<PARA>", "Did he show you?"
	db "<DONE>"
;@ path: text/FuchsiaPokecenter
_FuchsiaPokecenterRockerText::
	db TX_START, "You can't win"
	db "<LINE>", "with just one"
	db "<CONT>", "strong #MON."

	db "<PARA>", "It's tough, but"
	db "<LINE>", "you have to raise"
	db "<CONT>", "them evenly."
	db "<DONE>"

;@ path: text/FuchsiaPokecenter
_FuchsiaPokecenterCooltrainerFText::
	db TX_START, "There's a narrow"
	db "<LINE>", "trail west of"
	db "<CONT>", "VIRIDIAN CITY."

	db "<PARA>", "It goes to #MON"
	db "<LINE>", "LEAGUE HQ."
	db "<CONT>", "The HQ governs"
	db "<CONT>", "all trainers."
	db "<DONE>"
;@ path: text/WardensHouse
_WardensHouseWardenGibberish1Text::
	db TX_START, "WARDEN: Hif fuff"
	db "<LINE>", "hefifoo!"

	db "<PARA>", "Ha lof ha feef ee"
	db "<LINE>", "hafahi ho. Heff"
	db "<CONT>", "hee fwee!"
	db "<DONE>"

;@ path: text/WardensHouse
_WardensHouseWardenGibberish2Text::
	db TX_START, "Ah howhee ho hoo!"
	db "<LINE>", "Eef ee hafahi ho!"
	db "<DONE>"

;@ path: text/WardensHouse
_WardensHouseWardenGibberish3Text::
	db TX_START, "Ha? He ohay heh"
	db "<LINE>", "ha hoo ee haheh!"
	db "<DONE>"

;@ path: text/WardensHouse
_WardensHouseWardenGaveTheGoldTeethText::
	db TX_START, "<PLAYER> gave the"
	db "<LINE>", "GOLD TEETH to the"
	db "<CONT>", "WARDEN!@"
	db TX_END

;@ path: text/WardensHouse
_WardensHouseWardenTeethPoppedInHisTeethText::
	db TX_START

	db "<PARA>", "The WARDEN popped"
	db "<LINE>", "in his teeth!"
	db "<PROMPT>"

;@ path: text/WardensHouse
_WardensHouseWardenThanksText::
	db TX_START, "WARDEN: Thanks,"
	db "<LINE>", "kid! No one could"
	db "<CONT>", "understand a word"
	db "<CONT>", "that I said."

	db "<PARA>", "I couldn't work"
	db "<LINE>", "that way."
	db "<CONT>", "Let me give you"
	db "<CONT>", "something for"
	db "<CONT>", "your trouble."
	db "<PROMPT>"

;@ path: text/WardensHouse
_WardensHouseWardenReceivedHM04Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/WardensHouse
_WardensHouseWardenHM04ExplanationText::
	db TX_START, "WARDEN: HM04"
	db "<LINE>", "teaches STRENGTH!"

	db "<PARA>", "It lets #MON"
	db "<LINE>", "move boulders"
	db "<CONT>", "when you're out-"
	db "<CONT>", "side of battle."

	db "<PARA>", "Oh yes, did you"
	db "<LINE>", "find SECRET HOUSE"
	db "<CONT>", "in SAFARI ZONE?"

	db "<PARA>", "If you do, you"
	db "<LINE>", "win an HM!"

	db "<PARA>", "I hear it's the"
	db "<LINE>", "rare SURF HM."
	db "<DONE>"

;@ path: text/WardensHouse
_WardensHouseWardenHM04NoRoomText::
	db TX_START, "Your pack is"
	db "<LINE>", "stuffed full!"
	db "<DONE>"

;@ path: text/WardensHouse
_WardensHouseDisplayPhotosAndFossilsText::
	db TX_START, "#MON photos"
	db "<LINE>", "and fossils."
	db "<DONE>"

;@ path: text/WardensHouse
_WardensHouseDisplayMerchandiseText::
	db TX_START, "Old #MON"
	db "<LINE>", "merchandise."
	db "<DONE>"
;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1Text::
	db TX_START, "Welcome to the"
	db "<LINE>", "SAFARI ZONE!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText::
	db TX_START, "For just ¥500,"
	db "<LINE>", "you can catch all"
	db "<CONT>", "the #MON you"
	db "<CONT>", "want in the park!"

	db "<PARA>", "Would you like to"
	db "<LINE>", "join the hunt?@"
	db TX_END

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1ThatllBe500PleaseText::
	db TX_START, "That'll be ¥500"
	db "<LINE>", "please!"

	db "<PARA>", "We only use a"
	db "<LINE>", "special # BALL"
	db "<CONT>", "here."

	db "<PARA>", "<PLAYER> received"
	db "<LINE>", "30 SAFARI BALLs!@"
	db TX_END

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1CallYouOnThePAText::
	db TX_START

	db "<PARA>", "We'll call you on"
	db "<LINE>", "the PA when you"
	db "<CONT>", "run out of time"
	db "<CONT>", "or SAFARI BALLs!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1PleaseComeAgainText::
	db TX_START, "OK! Please come"
	db "<LINE>", "again!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1NotEnoughMoneyText::
	db TX_START, "Oops! Not enough"
	db "<LINE>", "money!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1LeavingEarlyText::
	db TX_START, "Leaving early?@"
	db TX_END

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1ReturnSafariBallsText::
	db TX_START, "Please return any"
	db "<LINE>", "SAFARI BALLs you"
	db "<CONT>", "have left."
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1GoodLuckText::
	db TX_START, "Good Luck!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText::
	db TX_START, "Did you get a"
	db "<LINE>", "good haul?"
	db "<CONT>", "Come again!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker2FirstTimeHereText::
	db TX_START, "Hi! Is it your"
	db "<LINE>", "first time here?"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker2SafariZoneExplanationText::
	db TX_START, "SAFARI ZONE has 4"
	db "<LINE>", "zones in it."

	db "<PARA>", "Each zone has"
	db "<LINE>", "different kinds"
	db "<CONT>", "of #MON. Use"
	db "<CONT>", "SAFARI BALLs to"
	db "<CONT>", "catch them!"

	db "<PARA>", "When you run out"
	db "<LINE>", "of time or SAFARI"
	db "<CONT>", "BALLs, it's game"
	db "<CONT>", "over for you!"

	db "<PARA>", "Before you go,"
	db "<LINE>", "open an unused"
	db "<CONT>", "#MON BOX so"
	db "<CONT>", "there's room for"
	db "<CONT>", "new #MON!"
	db "<DONE>"

;@ path: text/SafariZoneGate
_SafariZoneGateSafariZoneWorker2YoureARegularHereText::
	db TX_START, "Sorry, you're a"
	db "<LINE>", "regular here!"
	db "<DONE>"
;@ path: text/FuchsiaGym
_FuchsiaGymKogaBeforeBattleText::
	db TX_START, "KOGA: Fwahahaha!"

	db "<PARA>", "A mere child like"
	db "<LINE>", "you dares to"
	db "<CONT>", "challenge me?"

	db "<PARA>", "Very well, I"
	db "<LINE>", "shall show you"
	db "<CONT>", "true terror as a"
	db "<CONT>", "ninja master!"

	db "<PARA>", "You shall feel"
	db "<LINE>", "the despair of"
	db "<CONT>", "poison and sleep"
	db "<CONT>", "techniques!"
	db "<DONE>"

;@ path: text/FuchsiaGym
_FuchsiaGymKogaReceivedSoulBadgeText::
	db TX_START, "Humph!"
	db "<LINE>", "You have proven"
	db "<CONT>", "your worth!"

	db "<PARA>", "Here! Take the"
	db "<LINE>", "SOULBADGE!"
	db "<PROMPT>"


SECTION "Text 9", ROMX

;@ path: text/FuchsiaGym_2
_FuchsiaGymKogaPostBattleAdviceText::
	db TX_START, "When afflicted by"
	db "<LINE>", "TOXIC, #MON"
	db "<CONT>", "suffer more and"
	db "<CONT>", "more as battle"
	db "<CONT>", "progresses!"

	db "<PARA>", "It will surely"
	db "<LINE>", "terrorize foes!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymKogaSoulBadgeInfoText::
	db TX_START, "Now that you have"
	db "<LINE>", "the SOULBADGE,"
	db "<CONT>", "the DEFENSE of"
	db "<CONT>", "your #MON"
	db "<CONT>", "increases!"

	db "<PARA>", "It also lets you"
	db "<LINE>", "SURF outside of"
	db "<CONT>", "battle!"

	db "<PARA>", "Ah! Take this"
	db "<LINE>", "too!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymKogaReceivedTM06Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/FuchsiaGym_2
_FuchsiaGymKogaTM06ExplanationText::
	db TX_START

	db "<PARA>", "TM06 contains"
	db "<LINE>", "TOXIC!"

	db "<PARA>", "It is a secret"
	db "<LINE>", "technique over"
	db "<CONT>", "400 years old!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymKogaTM06NoRoomText::
	db TX_START, "Make space for"
	db "<LINE>", "this, child!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker1BattleText::
	db TX_START, "Strength isn't"
	db "<LINE>", "the key for"
	db "<CONT>", "#MON!"

	db "<PARA>", "It's strategy!"

	db "<PARA>", "I'll show you how"
	db "<LINE>", "strategy can beat"
	db "<CONT>", "brute strength!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker1EndBattleText::
	db TX_START, "What?"
	db "<LINE>", "Extraordinary!"
	db "<PROMPT>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker1AfterBattleText::
	db TX_START, "So, you mix brawn"
	db "<LINE>", "with brains?"
	db "<CONT>", "Good strategy!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker2BattleText::
	db TX_START, "I wanted to become"
	db "<LINE>", "a ninja, so I"
	db "<CONT>", "joined this GYM!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker2EndBattleText::
	db TX_START, "I'm done"
	db "<LINE>", "for!"
	db "<PROMPT>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker2AfterBattleText::
	db TX_START, "I will keep on"
	db "<LINE>", "training under"
	db "<CONT>", "KOGA, my ninja"
	db "<CONT>", "master!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker3BattleText::
	db TX_START, "Let's see you"
	db "<LINE>", "beat my special"
	db "<CONT>", "techniques!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker3EndBattleText::
	db TX_START, "You"
	db "<LINE>", "had me fooled!"
	db "<PROMPT>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker3AfterBattleText::
	db TX_START, "I like poison and"
	db "<LINE>", "sleep techniques,"
	db "<CONT>", "as they linger"
	db "<CONT>", "after battle!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker4BattleText::
	db TX_START, "Stop right there!"

	db "<PARA>", "Our invisible"
	db "<LINE>", "walls have you"
	db "<CONT>", "frustrated?"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker4EndBattleText::
	db TX_START, "Whoa!"
	db "<LINE>", "He's got it!"
	db "<PROMPT>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker4AfterBattleText::
	db TX_START, "You impressed me!"
	db "<LINE>", "Here's a hint!"

	db "<PARA>", "Look very closely"
	db "<LINE>", "for gaps in the"
	db "<CONT>", "invisible walls!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker5BattleText::
	db TX_START, "I also study the"
	db "<LINE>", "way of the ninja"
	db "<CONT>", "with master KOGA!"

	db "<PARA>", "Ninja have a long"
	db "<LINE>", "history of using"
	db "<CONT>", "animals!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker5EndBattleText::
	db TX_START, "Awoo!"
	db "<PROMPT>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker5AfterBattleText::
	db TX_START, "I still have much"
	db "<LINE>", "to learn!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker6BattleText::
	db TX_START, "Master KOGA comes"
	db "<LINE>", "from a long line"
	db "<CONT>", "of ninjas!"

	db "<PARA>", "What did you"
	db "<LINE>", "descend from?"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker6EndBattleText::
	db TX_START, "Dropped"
	db "<LINE>", "my balls!"
	db "<PROMPT>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymRocker6AfterBattleText::
	db TX_START, "Where there is"
	db "<LINE>", "light, there is"
	db "<CONT>", "shadow!"

	db "<PARA>", "Light and shadow!"
	db "<LINE>", "Which do you"
	db "<CONT>", "choose?"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymGymGuideChampInMakingText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "FUCHSIA GYM is"
	db "<LINE>", "riddled with"
	db "<CONT>", "invisible walls!"

	db "<PARA>", "KOGA might appear"
	db "<LINE>", "close, but he's"
	db "<CONT>", "blocked off!"

	db "<PARA>", "You have to find"
	db "<LINE>", "gaps in the walls"
	db "<CONT>", "to reach him!"
	db "<DONE>"

;@ path: text/FuchsiaGym_2
_FuchsiaGymGymGuideBeatKogaText::
	db TX_START, "It's amazing how"
	db "<LINE>", "ninja can terrify"
	db "<CONT>", "even now!"
	db "<DONE>"
;@ path: text/FuchsiaMeetingRoom
_FuchsiaMeetingRoomSafariZoneWorker1::
	db TX_START, "We nicknamed the"
	db "<LINE>", "WARDEN SLOWPOKE."

	db "<PARA>", "He and SLOWPOKE"
	db "<LINE>", "both look vacant!"
	db "<DONE>"

;@ path: text/FuchsiaMeetingRoom
_FuchsiaMeetingRoomSafariZoneWorker2::
	db TX_START, "SLOWPOKE is very"
	db "<LINE>", "knowledgeable"
	db "<CONT>", "about #MON!"

	db "<PARA>", "He even has some"
	db "<LINE>", "fossils of rare,"
	db "<CONT>", "extinct #MON!"
	db "<DONE>"

;@ path: text/FuchsiaMeetingRoom
_FuchsiaMeetingRoomSafariZoneWorker3::
	db TX_START, "SLOWPOKE came in,"
	db "<LINE>", "but I couldn't"
	db "<CONT>", "understand him."

	db "<PARA>", "I think he's got"
	db "<LINE>", "a speech problem!"
	db "<DONE>"
;@ path: text/FuchsiaGoodRodHouse
_FuchsiaGoodRodHouseFishingGuruText::
	db TX_START, "I'm the FISHING"
	db "<LINE>", "GURU's older"
	db "<CONT>", "brother!"

	db "<PARA>", "I simply Looove"
	db "<LINE>", "fishing!"

	db "<PARA>", "Do you like to"
	db "<LINE>", "fish?"
	db "<DONE>"

;@ path: text/FuchsiaGoodRodHouse
_FuchsiaGoodRodHouseFishingGuruReceivedGoodRodText::
	db TX_START, "Grand! I like"
	db "<LINE>", "your style!"

	db "<PARA>", "Take this and"
	db "<LINE>", "fish, young one!"

	db "<PARA>", "<PLAYER> received"
	db "<LINE>", "a @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/FuchsiaGoodRodHouse
_FuchsiaGoodRodHouseFishingGuruThatsSoDisappointingText::
	db TX_START, "Oh... That's so"
	db "<LINE>", "disappointing..."
	db "<DONE>"

;@ path: text/FuchsiaGoodRodHouse
_FuchsiaGoodRodHouseFishingGuruHowAreTheFishText::
	db TX_START, "Hello there,"
	db "<LINE>", "<PLAYER>!"

	db "<PARA>", "How are the fish"
	db "<LINE>", "biting?"
	db "<DONE>"

;@ path: text/FuchsiaGoodRodHouse
_FuchsiaGoodRodHouseFishingGuruNoRoomText::
	db TX_START, "Oh no!"

	db "<PARA>", "You have no room"
	db "<LINE>", "for my gift!"
	db "<DONE>"
;@ path: text/PokemonMansion1F
_PokemonMansion1FScientistBattleText::
	db TX_START, "Who are you? There"
	db "<LINE>", "shouldn't be"
	db "<CONT>", "anyone here."
	db "<DONE>"

;@ path: text/PokemonMansion1F
_PokemonMansion1FScientistEndBattleText::
	db TX_START, "Ouch!"
	db "<PROMPT>"

;@ path: text/PokemonMansion1F
_PokemonMansion1FScientistAfterBattleText::
	db TX_START, "A key? I don't"
	db "<LINE>", "know what you're"
	db "<CONT>", "talking about."
	db "<DONE>"

;@ path: text/PokemonMansion1F
_PokemonMansion1FSwitchText::
	db TX_START, "A secret switch!"

	db "<PARA>", "Press it?"
	db "<DONE>"

;@ path: text/PokemonMansion1F
_PokemonMansion1FSwitchPressedText::
	db TX_START, "Who wouldn't?"
	db "<PROMPT>"

;@ path: text/PokemonMansion1F
_PokemonMansion1FSwitchNotPressedText::
	db TX_START, "Not quite yet!"
	db "<DONE>"
;@ path: text/CinnabarGym
_CinnabarGymBlainePreBattleText::
	db TX_START, "Hah!"

	db "<PARA>", "I am BLAINE! I"
	db "<LINE>", "am the LEADER of"
	db "<CONT>", "CINNABAR GYM!"

	db "<PARA>", "My fiery #MON"
	db "<LINE>", "will incinerate"
	db "<CONT>", "all challengers!"

	db "<PARA>", "Hah! You better"
	db "<LINE>", "have BURN HEAL!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymBlaineReceivedVolcanoBadgeText::
	db TX_START, "I have"
	db "<LINE>", "burnt out!"

	db "<PARA>", "You have earned"
	db "<LINE>", "the VOLCANOBADGE!@"
	db TX_END

;@ path: text/CinnabarGym
_CinnabarGymBlainePostBattleAdviceText::
	db TX_START, "FIRE BLAST is the"
	db "<LINE>", "ultimate fire"
	db "<CONT>", "technique!"

	db "<PARA>", "Don't waste it on"
	db "<LINE>", "water #MON!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymBlaineVolcanoBadgeInfoText::
	db TX_START, "Hah!"

	db "<PARA>", "The VOLCANOBADGE"
	db "<LINE>", "heightens the"
	db "<CONT>", "SPECIAL abilities"
	db "<CONT>", "of your #MON!"

	db "<PARA>", "Here, you can"
	db "<LINE>", "have this too!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymBlaineReceivedTM38Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CinnabarGym
_CinnabarGymBlaineTM38ExplanationText::
	db TX_START

	db "<PARA>", "TM38 contains"
	db "<LINE>", "FIRE BLAST!"

	db "<PARA>", "Teach it to fire-"
	db "<LINE>", "type #MON!"

	db "<PARA>", "CHARMELEON or"
	db "<LINE>", "PONYTA would be"
	db "<CONT>", "good bets!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymBlaineTM38NoRoomText::
	db TX_START, "Make room for my"
	db "<LINE>", "gift!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd1BattleText::
	db TX_START, "Do you know how"
	db "<LINE>", "hot #MON fire"
	db "<CONT>", "breath can get?"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd1EndBattleText::
	db TX_START, "Yow!"
	db "<LINE>", "Hot, hot, hot!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd1AfterBattleText::
	db TX_START, "Fire, or to be"
	db "<LINE>", "more precise,"
	db "<CONT>", "combustion..."

	db "<PARA>", "Blah, blah, blah,"
	db "<LINE>", "blah..."
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd2BattleText::
	db TX_START, "I was a thief, but"
	db "<LINE>", "I became straight"
	db "<CONT>", "as a trainer!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd2EndBattleText::
	db TX_START, "I"
	db "<LINE>", "surrender!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd2AfterBattleText::
	db TX_START, "I can't help"
	db "<LINE>", "stealing other"
	db "<CONT>", "people's #MON!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd3BattleText::
	db TX_START, "You can't win!"
	db "<LINE>", "I have studied"
	db "<CONT>", "#MON totally!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd3EndBattleText::
	db TX_START, "Waah!"
	db "<LINE>", "My studies!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd3AfterBattleText::
	db TX_START, "My theories are"
	db "<LINE>", "too complicated"
	db "<CONT>", "for you!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd4BattleText::
	db TX_START, "I just like using"
	db "<LINE>", "fire #MON!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd4EndBattleText::
	db TX_START, "Too hot"
	db "<LINE>", "to handle!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd4AfterBattleText::
	db TX_START, "I wish there was"
	db "<LINE>", "a thief #MON!"
	db "<CONT>", "I'd use that!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd5BattleText::
	db TX_START, "I know why BLAINE"
	db "<LINE>", "became a trainer!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd5EndBattleText::
	db TX_START, "Ow!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd5AfterBattleText::
	db TX_START, "BLAINE was lost"
	db "<LINE>", "in the mountains"
	db "<CONT>", "when a fiery bird"
	db "<CONT>", "#MON appeared."

	db "<PARA>", "Its light enabled"
	db "<LINE>", "BLAINE to find"
	db "<CONT>", "his way down!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd6BattleText::
	db TX_START, "I've been to many"
	db "<LINE>", "GYMs, but this is"
	db "<CONT>", "my favorite!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd6EndBattleText::
	db TX_START, "Yowza!"
	db "<LINE>", "Too hot!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd6AfterBattleText::
	db TX_START, "Us fire #MON"
	db "<LINE>", "fans like PONYTA"
	db "<CONT>", "and NINETALES!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd7BattleText::
	db TX_START, "Fire is weak"
	db "<LINE>", "against H2O!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd7EndBattleText::
	db TX_START, "Oh!"
	db "<LINE>", "Snuffed out!"
	db "<PROMPT>"

;@ path: text/CinnabarGym
_CinnabarGymSuperNerd7AfterBattleText::
	db TX_START, "Water beats fire!"
	db "<LINE>", "But, fire melts"
	db "<CONT>", "ice #MON!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymGymGuideChampInMakingText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "The hot-headed"
	db "<LINE>", "BLAINE is a fire"
	db "<CONT>", "#MON pro!"

	db "<PARA>", "Douse his spirits"
	db "<LINE>", "with water!"

	db "<PARA>", "You better take"
	db "<LINE>", "some BURN HEALs!"
	db "<DONE>"

;@ path: text/CinnabarGym
_CinnabarGymGymGuideBeatBlaineText::
	db TX_START, "<PLAYER>! You beat"
	db "<LINE>", "that fire brand!"
	db "<DONE>"
;@ path: text/CinnabarLab
_CinnabarLabFishingGuruText::
	db TX_START, "We study #MON"
	db "<LINE>", "extensively here."

	db "<PARA>", "People often bring"
	db "<LINE>", "us rare #MON"
	db "<CONT>", "for examination."
	db "<DONE>"

;@ path: text/CinnabarLab
_CinnabarLabPhotoText::
	db TX_START, "A photo of the"
	db "<LINE>", "LAB's founder,"
	db "<CONT>", "DR.FUJI!"
	db "<DONE>"

;@ path: text/CinnabarLab
_CinnabarLabMeetingRoomSignText::
	db TX_START, "#MON LAB"
	db "<LINE>", "Meeting Room"
	db "<DONE>"

;@ path: text/CinnabarLab
_CinnabarLabRAndDSignText::
	db TX_START, "#MON LAB"
	db "<LINE>", "R-and-D Room"
	db "<DONE>"

;@ path: text/CinnabarLab
_CinnabarLabTestingRoomSignText::
	db TX_START, "#MON LAB"
	db "<LINE>", "Testing Room"
	db "<DONE>"
;@ path: text/CinnabarLabTradeRoom
_CinnabarLabTradeRoomSuperNerdText::
	db TX_START, "I found this very"
	db "<LINE>", "strange fossil in"
	db "<CONT>", "MT.MOON!"

	db "<PARA>", "I think it's a"
	db "<LINE>", "rare, prehistoric"
	db "<CONT>", "#MON!"
	db "<DONE>"
;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomScientist1Text::
	db TX_START, "Tch-tch-tch!"
	db "<LINE>", "I made a cool TM!"

	db "<PARA>", "It can cause all"
	db "<LINE>", "kinds of fun!"
	db "<PROMPT>"

;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomScientist1ReceivedTM35Text::
	db TX_START, "<PLAYER> received "
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomScientist1TM35ExplanationText::
	db TX_START, "Tch-tch-tch!"
	db "<LINE>", "That's the sound"
	db "<CONT>", "of a METRONOME!"

	db "<PARA>", "It tweaks your"
	db "<LINE>", "#MON's brain"
	db "<CONT>", "into using moves"
	db "<CONT>", "it doesn't know!"
	db "<DONE>"

;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomScientist1TM35NoRoomText::
	db TX_START, "Your pack is"
	db "<LINE>", "crammed full!"
	db "<DONE>"

;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomScientist2Text::
	db TX_START, "EEVEE can evolve"
	db "<LINE>", "into 1 of 3 kinds"
	db "<CONT>", "of #MON."
	db "<DONE>"

;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomPCText::
	db TX_START, "There's an e-mail"
	db "<LINE>", "message!"

	db "<PARA>", "..."

	db "<PARA>", "The 3 legendary"
	db "<LINE>", "bird #MON are"
	db "<CONT>", "ARTICUNO, ZAPDOS"
	db "<CONT>", "and MOLTRES."

	db "<PARA>", "Their whereabouts"
	db "<LINE>", "are unknown."

	db "<PARA>", "We plan to explore"
	db "<LINE>", "the cavern close"
	db "<CONT>", "to CERULEAN."

	db "<PARA>", "From: #MON"
	db "<LINE>", "RESEARCH TEAM"

	db "<PARA>", "..."
	db "<DONE>"

;@ path: text/CinnabarLabMetronomeRoom
_CinnabarLabMetronomeRoomAmberPipeText::
	db TX_START, "An amber pipe!"
	db "<DONE>"
;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1Text::
	db TX_START, "Hiya!"

	db "<PARA>", "I am important"
	db "<LINE>", "doctor!"

	db "<PARA>", "I study here rare"
	db "<LINE>", "#MON fossils!"

	db "<PARA>", "You! Have you a"
	db "<LINE>", "fossil for me?"
	db "<PROMPT>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1NoFossilsText::
	db TX_START, "No! Is too bad!"
	db "<DONE>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1GoForAWalkText::
	db TX_START, "I take a little"
	db "<LINE>", "time!"

	db "<PARA>", "You go for walk a"
	db "<LINE>", "little while!"
	db "<DONE>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1FossilIsBackToLifeText::
	db TX_START, "Where were you?"

	db "<PARA>", "Your fossil is"
	db "<LINE>", "back to life!"

	db "<PARA>", "It was @"
	db TX_RAM
	dw wStringBuffer
	db TX_START
	db "<LINE>", "like I think!"
	db "<PROMPT>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1SeesFossilText::
	db TX_START, "Oh! That is"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"

	db "<PARA>", "It is fossil of"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, ", a"
	db "<CONT>", "#MON that is"
	db "<CONT>", "already extinct!"

	db "<PARA>", "My Resurrection"
	db "<LINE>", "Machine will make"
	db "<CONT>", "that #MON live"
	db "<CONT>", "again!"
	db "<DONE>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1TakesFossilText::
	db TX_START, "So! You hurry and"
	db "<LINE>", "give me that!"

	db "<PARA>", "<PLAYER> handed"
	db "<LINE>", "over @"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1GoForAWalkText2::
	db TX_START, "I take a little"
	db "<LINE>", "time!"

	db "<PARA>", "You go for walk a"
	db "<LINE>", "little while!"
	db "<DONE>"

;@ path: text/CinnabarLabFossilRoom
_CinnabarLabFossilRoomScientist1ComeAgainText::
	db TX_START, "Aiyah! You come"
	db "<LINE>", "again!"
	db "<DONE>"
;@ path: text/CinnabarPokecenter
_CinnabarPokecenterCooltrainerFText::
	db TX_START, "You can cancel"
	db "<LINE>", "evolution."

	db "<PARA>", "When a #MON is"
	db "<LINE>", "evolving, you can"
	db "<CONT>", "stop it and leave"
	db "<CONT>", "it the way it is."
	db "<DONE>"

;@ path: text/CinnabarPokecenter
_CinnabarPokecenterGentlemanText::
	db TX_START, "Do you have any"
	db "<LINE>", "friends?"

	db "<PARA>", "#MON you get"
	db "<LINE>", "in trades grow"
	db "<CONT>", "very quickly."

	db "<PARA>", "I think it's"
	db "<LINE>", "worth a try!"
	db "<DONE>"
;@ path: text/CinnabarMart
_CinnabarMartSilphWorkerFText::
	db TX_START, "Don't they have X"
	db "<LINE>", "ATTACK? It's good"
	db "<CONT>", "for battles!"
	db "<DONE>"

;@ path: text/CinnabarMart
_CinnabarMartScientistText::
	db TX_START, "It never hurts to"
	db "<LINE>", "have extra items!"
	db "<DONE>"
;@ path: text/IndigoPlateauLobby
_IndigoPlateauLobbyGymGuideText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "At #MON LEAGUE,"
	db "<LINE>", "you have to face"
	db "<CONT>", "the ELITE FOUR in"
	db "<CONT>", "succession."

	db "<PARA>", "If you lose, you"
	db "<LINE>", "have to start all"
	db "<CONT>", "over again! This"
	db "<CONT>", "is it! Go for it!"
	db "<DONE>"

;@ path: text/IndigoPlateauLobby
_IndigoPlateauLobbyCooltrainerFText::
	db TX_START, "From here on, you"
	db "<LINE>", "face the ELITE"
	db "<CONT>", "FOUR one by one!"

	db "<PARA>", "If you win, a"
	db "<LINE>", "door opens to the"
	db "<CONT>", "next trainer!"
	db "<CONT>", "Good luck!"
	db "<DONE>"
;@ path: text/CopycatsHouse1F
_CopycatsHouse1FMiddleAgedWomanText::
	db TX_START, "My daughter is so"
	db "<LINE>", "self-centered."
	db "<CONT>", "She only has a"
	db "<CONT>", "few friends."
	db "<DONE>"

;@ path: text/CopycatsHouse1F
_CopycatsHouse1FMiddleAgedManText::
	db TX_START, "My daughter likes"
	db "<LINE>", "to mimic people."

	db "<PARA>", "Her mimicry has"
	db "<LINE>", "earned her the"
	db "<CONT>", "nickname COPYCAT"
	db "<CONT>", "around here!"
	db "<DONE>"

;@ path: text/CopycatsHouse1F
_CopycatsHouse1FChanseyText::
	db TX_START, "CHANSEY: Chaan!"
	db "<LINE>", "Sii!@"
	db TX_END
;@ path: text/CopycatsHouse2F
_CopycatsHouse2FCopycatDoYouLikePokemonText::
	db TX_START, "<PLAYER>: Hi! Do"
	db "<LINE>", "you like #MON?"

	db "<PARA>", "<PLAYER>: Uh no, I"
	db "<LINE>", "just asked you."

	db "<PARA>", "<PLAYER>: Huh?"
	db "<LINE>", "You're strange!"

	db "<PARA>", "COPYCAT: Hmm?"
	db "<LINE>", "Quit mimicking?"

	db "<PARA>", "But, that's my"
	db "<LINE>", "favorite hobby!"
	db "<PROMPT>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FCopycatTM31PreReceiveText::
	db TX_START, "Oh wow!"
	db "<LINE>", "A # DOLL!"

	db "<PARA>", "For me?"
	db "<LINE>", "Thank you!"

	db "<PARA>", "You can have"
	db "<LINE>", "this, then!"
	db "<PROMPT>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FCopycatReceivedTM31Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FCopycatTM31Explanation1Text::
	db TX_START

	db "<PARA>", "TM31 contains my"
	db "<LINE>", "favorite, MIMIC!"

	db "<PARA>", "Use it on a good"
	db "<LINE>", "#MON!@"
	db TX_END

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FCopycatTM31Explanation2Text::
	db TX_START, "<PLAYER>: Hi!"
	db "<LINE>", "Thanks for TM31!"

	db "<PARA>", "<PLAYER>: Pardon?"

	db "<PARA>", "<PLAYER>: Is it"
	db "<LINE>", "that fun to mimic"
	db "<CONT>", "my every move?"

	db "<PARA>", "COPYCAT: You bet!"
	db "<LINE>", "It's a scream!"
	db "<DONE>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FCopycatTM31NoRoomText::
	db TX_START, "Don't you want"
	db "<LINE>", "this?@"
	db TX_END

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FDoduoText::
	db TX_START, "DODUO: Giiih!"

	db "<PARA>", "MIRROR MIRROR ON"
	db "<LINE>", "THE WALL, WHO IS"
	db "<CONT>", "THE FAIREST ONE"
	db "<CONT>", "OF ALL?"
	db "<DONE>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FRareDollText::
	db TX_START, "This is a rare"
	db "<LINE>", "#MON! Huh?"
	db "<CONT>", "It's only a doll!"
	db "<DONE>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FSNESText::
	db TX_START, "A game with MARIO"
	db "<LINE>", "wearing a bucket"
	db "<CONT>", "on his head!"
	db "<DONE>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FPCMySecretsText::
	db TX_START, "..."

	db "<PARA>", "My Secrets!"

	db "<PARA>", "Skill: Mimicry!"
	db "<LINE>", "Hobby: Collecting"
	db "<CONT>", "dolls!"
	db "<CONT>", "Favorite #MON:"
	db "<CONT>", "CLEFAIRY!"
	db "<DONE>"

;@ path: text/CopycatsHouse2F
_CopycatsHouse2FPCCantSeeText::
	db TX_START, "Huh? Can't see!"
	db "<DONE>"
;@ path: text/FightingDojo
_FightingDojoKarateMasterText::
	db TX_START, "Grunt!"

	db "<PARA>", "I am the KARATE"
	db "<LINE>", "MASTER! I am the"
	db "<CONT>", "LEADER here!"

	db "<PARA>", "You wish to"
	db "<LINE>", "challenge us?"
	db "<CONT>", "Expect no mercy!"

	db "<PARA>", "Fwaaa!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoKarateMasterDefeatedText::
	db TX_START, "Hwa!"
	db "<LINE>", "Arrgh! Beaten!"
	db "<PROMPT>"

;@ path: text/FightingDojo
_FightingDojoKarateMasterIWillGiveYouAPokemonText::
	db TX_START, "Indeed, I have"
	db "<LINE>", "lost!"

	db "<PARA>", "But, I beseech"
	db "<LINE>", "you, do not take"
	db "<CONT>", "our emblem as"
	db "<CONT>", "your trophy!"

	db "<PARA>", "In return, I will"
	db "<LINE>", "give you a prized"
	db "<CONT>", "fighting #MON!"

	db "<PARA>", "Choose whichever"
	db "<LINE>", "one you like!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoKarateMasterStayAndTrainWithUsText::
	db TX_START, "Ho!"

	db "<PARA>", "Stay and train at"
	db "<LINE>", "Karate with us!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt1BattleText::
	db TX_START, "Hoargh! Take your"
	db "<LINE>", "shoes off!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt1EndBattleText::
	db TX_START, "I give"
	db "<LINE>", "up!"
	db "<PROMPT>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt1AfterBattleText::
	db TX_START, "You wait 'til you"
	db "<LINE>", "see our Master!"

	db "<PARA>", "I'm a small fry"
	db "<LINE>", "compared to him!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt2BattleText::
	db TX_START, "I hear you're"
	db "<LINE>", "good! Show me!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt2EndBattleText::
	db TX_START, "Judge!"
	db "<LINE>", "1 point!"
	db "<PROMPT>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt2AfterBattleText::
	db TX_START, "Our Master is a"
	db "<LINE>", "pro fighter!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt3BattleText::
	db TX_START, "Nothing tough"
	db "<LINE>", "frightens me!"

	db "<PARA>", "I break boulders"
	db "<LINE>", "for training!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt3EndBattleText::
	db TX_START, "Yow!"
	db "<LINE>", "Stubbed fingers!"
	db "<PROMPT>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt3AfterBattleText::
	db TX_START, "The only thing"
	db "<LINE>", "that frightens us"
	db "<CONT>", "is psychic power!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt4BattleText::
	db TX_START, "Hoohah!"

	db "<PARA>", "You're trespassing"
	db "<LINE>", "in our FIGHTING"
	db "<CONT>", "DOJO!"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt4EndBattleText::
	db TX_START, "Oof!"
	db "<LINE>", "I give up!"
	db "<PROMPT>"

;@ path: text/FightingDojo
_FightingDojoBlackbelt4AfterBattleText::
	db TX_START, "The prime fighters"
	db "<LINE>", "across the land"
	db "<CONT>", "train here."
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoHitmonleePokeBallText::
	db TX_START, "You want the"
	db "<LINE>", "hard kicking"
	db "<CONT>", "HITMONLEE?"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoHitmonchanPokeBallText::
	db TX_START, "You want the"
	db "<LINE>", "piston punching"
	db "<CONT>", "HITMONCHAN?"
	db "<DONE>"

;@ path: text/FightingDojo
_FightingDojoBetterNotGetGreedyText::
	db TX_START, "Better not get"
	db "<LINE>", "greedy..."
	db "<DONE>"
;@ path: text/SaffronGym
_SaffronGymSabrinaText::
	db TX_START, "I had a vision of"
	db "<LINE>", "your arrival!"

	db "<PARA>", "I have had psychic"
	db "<LINE>", "powers since I"
	db "<CONT>", "was a child."

	db "<PARA>", "I first learned"
	db "<LINE>", "to bend spoons"
	db "<CONT>", "with my mind."

	db "<PARA>", "I dislike fight-"
	db "<LINE>", "ing, but if you"
	db "<CONT>", "wish, I will show"
	db "<CONT>", "you my powers!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymSabrinaReceivedMarshBadgeText::
	db TX_START, "I'm"
	db "<LINE>", "shocked!"
	db "<CONT>", "But, a loss is a"
	db "<CONT>", "loss."

	db "<PARA>", "I admit I didn't"
	db "<LINE>", "work hard enough"
	db "<CONT>", "to win!"

	db "<PARA>", "You earned the"
	db "<LINE>", "MARSHBADGE!@"
	db TX_END

;@ path: text/SaffronGym
_SaffronGymSabrinaPostBattleAdviceText::
	db TX_START, "Everyone has"
	db "<LINE>", "psychic power!"
	db "<CONT>", "People just don't"
	db "<CONT>", "realize it!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymSabrinaMarshBadgeInfoText::
	db TX_START, "The MARSHBADGE"
	db "<LINE>", "makes #MON up"
	db "<CONT>", "to L70 obey you!"

	db "<PARA>", "Stronger #MON"
	db "<LINE>", "will become wild,"
	db "<CONT>", "ignoring your"
	db "<CONT>", "orders in battle!"

	db "<PARA>", "Just don't raise"
	db "<LINE>", "your #MON too"
	db "<CONT>", "much!"

	db "<PARA>", "Wait, please take"
	db "<LINE>", "this TM with you!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymSabrinaReceivedTM46Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM46!@"
	db TX_END

;@ path: text/SaffronGym
_TM46ExplanationText::
	db TX_START

	db "<PARA>", "TM46 is PSYWAVE!"
	db "<LINE>", "It uses powerful"
	db "<CONT>", "psychic waves to"
	db "<CONT>", "inflict damage!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymSabrinaTM46NoRoomText::
	db TX_START, "Your pack is full"
	db "<LINE>", "of other items!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymGuideChampInMakingText::
	db TX_START, "Yo! Champ in"
	db "<LINE>", "making!"

	db "<PARA>", "SABRINA's #MON"
	db "<LINE>", "use psychic power"
	db "<CONT>", "instead of force!"

	db "<PARA>", "Fighting #MON"
	db "<LINE>", "are weak against"
	db "<CONT>", "psychic #MON!"

	db "<PARA>", "They get creamed"
	db "<LINE>", "before they can"
	db "<CONT>", "even aim a punch!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymGuideBeatSabrinaText::
	db TX_START, "Psychic power,"
	db "<LINE>", "huh?"

	db "<PARA>", "If I had that,"
	db "<LINE>", "I'd make a bundle"
	db "<CONT>", "at the slots!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymChanneler1BattleText::
	db TX_START, "SABRINA is younger"
	db "<LINE>", "than I, but I"
	db "<CONT>", "respect her!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymChanneler1EndBattleText::
	db TX_START, "Not"
	db "<LINE>", "good enough!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymChanneler1AfterBattleText::
	db TX_START, "In a battle of"
	db "<LINE>", "equals, the one"
	db "<CONT>", "with the stronger"
	db "<CONT>", "will wins!"

	db "<PARA>", "If you wish"
	db "<LINE>", "to beat SABRINA,"
	db "<CONT>", "focus on winning!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster1BattleText::
	db TX_START, "Does our unseen"
	db "<LINE>", "power scare you?"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster1EndBattleText::
	db TX_START, "I never"
	db "<LINE>", "foresaw this!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymYoungster1AfterBattleText::
	db TX_START, "Psychic #MON"
	db "<LINE>", "fear only ghosts"
	db "<CONT>", "and bugs!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymChanneler2BattleText::
	db TX_START, "#MON take on"
	db "<LINE>", "the appearance of"
	db "<CONT>", "their trainers."

	db "<PARA>", "Your #MON must"
	db "<LINE>", "be tough, then!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymChanneler2EndBattleText::
	db TX_START, "I knew"
	db "<LINE>", "it!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymChanneler2AfterBattleText::
	db TX_START, "I must teach"
	db "<LINE>", "better techniques"
	db "<CONT>", "to my #MON!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster2BattleText::
	db TX_START, "You know that"
	db "<LINE>", "power alone isn't"
	db "<CONT>", "enough!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster2EndBattleText::
	db TX_START, "I don't"
	db "<LINE>", "believe this!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymYoungster2AfterBattleText::
	db TX_START, "SABRINA just wiped"
	db "<LINE>", "out the KARATE"
	db "<CONT>", "MASTER next door!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymChanneler3BattleText::
	db TX_START, "You and I, our"
	db "<LINE>", "#MON shall"
	db "<CONT>", "fight!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymChanneler3EndBattleText::
	db TX_START, "I lost"
	db "<LINE>", "after all!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymChanneler3AfterBattleText::
	db TX_START, "I knew that this"
	db "<LINE>", "was going to take"
	db "<CONT>", "place."
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster3BattleText::
	db TX_START, "SABRINA is young,"
	db "<LINE>", "but she's also"
	db "<CONT>", "our LEADER!"

	db "<PARA>", "You won't reach"
	db "<LINE>", "her easily!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster3EndBattleText::
	db TX_START, "I lost"
	db "<LINE>", "my concentration!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymYoungster3AfterBattleText::
	db TX_START, "There used to be"
	db "<LINE>", "2 #MON GYMs in"
	db "<CONT>", "SAFFRON."

	db "<PARA>", "The FIGHTING DOJO"
	db "<LINE>", "next door lost"
	db "<CONT>", "its GYM status"
	db "<CONT>", "when we went and"
	db "<CONT>", "creamed them!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster4BattleText::
	db TX_START, "SAFFRON #MON"
	db "<LINE>", "GYM is famous for"
	db "<CONT>", "its psychics!"

	db "<PARA>", "You want to see"
	db "<LINE>", "SABRINA!"
	db "<CONT>", "I can tell!"
	db "<DONE>"

;@ path: text/SaffronGym
_SaffronGymYoungster4EndBattleText::
	db TX_START, "Arrrgh!"
	db "<PROMPT>"

;@ path: text/SaffronGym
_SaffronGymYoungster4AfterBattleText::
	db TX_START, "That's right! I"
	db "<LINE>", "used telepathy to"
	db "<CONT>", "read your mind!"
	db "<DONE>"
;@ path: text/SaffronPidgeyHouse
_SaffronPidgeyHouseBrunetteGirlText::
	db TX_START, "Thank you for"
	db "<LINE>", "writing. I hope"
	db "<CONT>", "to see you soon!"

	db "<PARA>", "Hey! Don't look"
	db "<LINE>", "at my letter!"
	db "<DONE>"

;@ path: text/SaffronPidgeyHouse
_SaffronPidgeyHousePidgeyText::
	db TX_START, "PIDGEY: Kurukkoo!@"
	db TX_END

;@ path: text/SaffronPidgeyHouse
_SaffronPidgeyHouseYoungsterText::
	db TX_START, "The COPYCAT is"
	db "<LINE>", "cute! I'm getting"
	db "<CONT>", "her a # DOLL!"
	db "<DONE>"

;@ path: text/SaffronPidgeyHouse
_SaffronPidgeyHousePaperText::
	db TX_START, "I was given a PP"
	db "<LINE>", "UP as a gift."

	db "<PARA>", "It's used for"
	db "<LINE>", "increasing the PP"
	db "<CONT>", "of techniques!"
	db "<DONE>"
;@ path: text/SaffronMart
_SaffronMartSuperNerdText::
	db TX_START, "MAX REPEL lasts"
	db "<LINE>", "longer than SUPER"
	db "<CONT>", "REPEL for keeping"
	db "<CONT>", "weaker #MON"
	db "<CONT>", "away!"
	db "<DONE>"

;@ path: text/SaffronMart
_SaffronMartCooltrainerFText::
	db TX_START, "REVIVE is costly,"
	db "<LINE>", "but it revives"
	db "<CONT>", "fainted #MON!"
	db "<DONE>"
;@ path: text/SilphCo1F
_SilphCo1FLinkReceptionistText::
	db TX_START, "Welcome!"

	db "<PARA>", "The PRESIDENT is"
	db "<LINE>", "in the boardroom"
	db "<CONT>", "on 11F!"
	db "<DONE>"
;@ path: text/SaffronPokecenter
_SaffronPokecenterBeautyText::
	db TX_START, "#MON growth"
	db "<LINE>", "rates differ from"
	db "<CONT>", "specie to specie."
	db "<DONE>"

;@ path: text/SaffronPokecenter
_SaffronPokecenterGentlemanText::
	db TX_START, "SILPH CO. is very"
	db "<LINE>", "famous. That's"
	db "<CONT>", "why it attracted"
	db "<CONT>", "TEAM ROCKET!"
	db "<DONE>"
;@ path: text/MrPsychicsHouse
_MrPsychicsHouseMrPsychicYouWantedThisText::
	db TX_START, "...Wait! Don't"
	db "<LINE>", "say a word!"

	db "<PARA>", "You wanted this!"
	db "<PROMPT>"

;@ path: text/MrPsychicsHouse
_MrPsychicsHouseMrPsychicReceivedTM29Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/MrPsychicsHouse
_MrPsychicsHouseMrPsychicTM29ExplanationText::
	db TX_START, "TM29 is PSYCHIC!"

	db "<PARA>", "It can lower the"
	db "<LINE>", "target's SPECIAL"
	db "<CONT>", "abilities."
	db "<DONE>"

;@ path: text/MrPsychicsHouse
_MrPsychicsHouseMrPsychicTM29NoRoomText::
	db TX_START, "Where do you plan"
	db "<LINE>", "to put this?"
	db "<DONE>"

;@ path: data/text/text_4
_PokemartGreetingText::
	db TX_START, "Hi there!"
	db "<NEXT>", "May I help you?"
	db "<DONE>"

;@ path: data/text/text_4
_PokemonFaintedText::
	db TX_RAM
	dw wNameBuffer
	db TX_START
	db "<LINE>", "fainted!"
	db "<DONE>"

;@ path: data/text/text_4
_PlayerBlackedOutText::
	db TX_START, "<PLAYER> is out of"
	db "<LINE>", "useable #MON!"

	db "<PARA>", "<PLAYER> blacked"
	db "<LINE>", "out!"
	db "<PROMPT>"

;@ path: data/text/text_4
_RepelWoreOffText::
	db TX_START, "REPEL's effect"
	db "<LINE>", "wore off."
	db "<DONE>"

;@ path: data/text/text_4
_PokemartBuyingGreetingText::
	db TX_START, "Take your time."
	db "<DONE>"

;@ path: data/text/text_4
_PokemartTellBuyPriceText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, "?"
	db "<LINE>", "That will be"
	db "<CONT>", "¥@"
	db TX_BCD
	dw hMoney
	db 3 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START, ". OK?"
	db "<DONE>"

;@ path: data/text/text_4
_PokemartBoughtItemText::
	db TX_START, "Here you are!"
	db "<LINE>", "Thank you!"
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemartNotEnoughMoneyText::
	db TX_START, "You don't have"
	db "<LINE>", "enough money."
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemartItemBagFullText::
	db TX_START, "You can't carry"
	db "<LINE>", "any more items."
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemonSellingGreetingText::
	db TX_START, "What would you"
	db "<LINE>", "like to sell?"
	db "<DONE>"

;@ path: data/text/text_4
_PokemartTellSellPriceText::
	db TX_START, "I can pay you"
	db "<LINE>", "¥@"
	db TX_BCD
	dw hMoney
	db 3 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START, " for that."
	db "<DONE>"

;@ path: data/text/text_4
_PokemartItemBagEmptyText::
	db TX_START, "You don't have"
	db "<LINE>", "anything to sell."
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemartUnsellableItemText::
	db TX_START, "I can't put a"
	db "<LINE>", "price on that."
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemartThankYouText::
	db TX_START, "Thank you!"
	db "<DONE>"

;@ path: data/text/text_4
_PokemartAnythingElseText::
	db TX_START, "Is there anything"
	db "<LINE>", "else I can do?"
	db "<DONE>"

;@ path: data/text/text_4
_LearnedMove1Text::
	db TX_RAM
	dw wLearnMoveMonName
	db TX_START, " learned"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_4
_WhichMoveToForgetText::
	db TX_START, "Which move should"
	db "<NEXT>", "be forgotten?"
	db "<DONE>"

;@ path: data/text/text_4
_AbandonLearningText::
	db TX_START, "Abandon learning"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "?"
	db "<DONE>"

;@ path: data/text/text_4
_DidNotLearnText::
	db TX_RAM
	dw wLearnMoveMonName
	db TX_START
	db "<LINE>", "did not learn"
	db "<CONT>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_4
_TryingToLearnText::
	db TX_RAM
	dw wLearnMoveMonName
	db TX_START, " is"
	db "<LINE>", "trying to learn"
	db "<CONT>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"

	db "<PARA>", "But, @"
	db TX_RAM
	dw wLearnMoveMonName
	db TX_START
	db "<LINE>", "can't learn more"
	db "<CONT>", "than 4 moves!"

	db "<PARA>", "Delete an older"
	db "<LINE>", "move to make room"
	db "<CONT>", "for @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "?"
	db "<DONE>"

;@ path: data/text/text_4
_OneTwoAndText::
	db TX_START, "1, 2 and...@"
	db TX_END

;@ path: data/text/text_4
_PoofText::
	db TX_START, " Poof!@"
	db TX_END

;@ path: data/text/text_4
_ForgotAndText::
	db TX_START

	db "<PARA>", "@"
	db TX_RAM
	dw wLearnMoveMonName
	db TX_START, " forgot"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"

	db "<PARA>", "And..."
	db "<PROMPT>"

;@ path: data/text/text_4
_HMCantDeleteText::
	db TX_START, "HM techniques"
	db "<LINE>", "can't be deleted!"
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemonCenterWelcomeText::
	db TX_START, "Welcome to our"
	db "<LINE>", "#MON CENTER!"

	db "<PARA>", "We heal your"
	db "<LINE>", "#MON back to"
	db "<CONT>", "perfect health!"
	db "<PROMPT>"

;@ path: data/text/text_4
_ShallWeHealYourPokemonText::
	db TX_START, "Shall we heal your"
	db "<LINE>", "#MON?"
	db "<DONE>"

;@ path: data/text/text_4
_NeedYourPokemonText::
	db TX_START, "OK. We'll need"
	db "<LINE>", "your #MON."
	db "<DONE>"

;@ path: data/text/text_4
_PokemonFightingFitText::
	db TX_START, "Thank you!"
	db "<LINE>", "Your #MON are"
	db "<CONT>", "fighting fit!"
	db "<PROMPT>"

;@ path: data/text/text_4
_PokemonCenterFarewellText::
	db TX_START, "We hope to see"
	db "<LINE>", "you again!"
	db "<DONE>"

;@ path: data/text/text_4
_CableClubNPCAreaReservedFor2FriendsLinkedByCableText::
	db TX_START, "This area is"
	db "<LINE>", "reserved for 2"
	db "<CONT>", "friends who are"
	db "<CONT>", "linked by cable."
	db "<DONE>"

;@ path: data/text/text_4
_CableClubNPCWelcomeText::
	db TX_START, "Welcome to the"
	db "<LINE>", "Cable Club!"
	db "<DONE>"

;@ path: data/text/text_4
_CableClubNPCPleaseApplyHereHaveToSaveText::
	db TX_START, "Please apply here."

	db "<PARA>", "Before opening"
	db "<LINE>", "the link, we have"
	db "<CONT>", "to save the game."
	db "<DONE>"

;@ path: data/text/text_4
_CableClubNPCPleaseWaitText::
	db TX_START, "Please wait.@"
	db TX_END

;@ path: data/text/text_4
_CableClubNPCLinkClosedBecauseOfInactivityText::
	db TX_START, "The link has been"
	db "<LINE>", "closed because of"
	db "<CONT>", "inactivity."

	db "<PARA>", "Please contact"
	db "<LINE>", "your friend and"
	db "<CONT>", "come again!"
	db "<DONE>"


SECTION "Text 10", ROMX

;@ path: data/text/text_5
_CableClubNPCPleaseComeAgainText::
	db TX_START, "Please come again!"
	db "<DONE>"

;@ path: data/text/text_5
_CableClubNPCMakingPreparationsText::
	db TX_START, "We're making"
	db "<LINE>", "preparations."
	db "<CONT>", "Please wait."
	db "<DONE>"

;@ path: data/text/text_5
_UsedStrengthText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " used"
	db "<LINE>", "STRENGTH.@"
	db TX_END

;@ path: data/text/text_5
_CanMoveBouldersText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " can"
	db "<LINE>", "move boulders."
	db "<PROMPT>"

;@ path: data/text/text_5
_CurrentTooFastText::
	db TX_START, "The current is"
	db "<LINE>", "much too fast!"
	db "<PROMPT>"

;@ path: data/text/text_5
_CyclingIsFunText::
	db TX_START, "Cycling is fun!"
	db "<LINE>", "Forget SURFing!"
	db "<PROMPT>"

;@ path: data/text/text_5
_FlashLightsAreaText::
	db TX_START, "A blinding FLASH"
	db "<LINE>", "lights the area!"
	db "<PROMPT>"

;@ path: data/text/text_5
_WarpToLastPokemonCenterText::
	db TX_START, "Warp to the last"
	db "<LINE>", "#MON CENTER."
	db "<DONE>"

;@ path: data/text/text_5
_CannotUseTeleportNowText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " can't"
	db "<LINE>", "use TELEPORT now."
	db "<PROMPT>"

;@ path: data/text/text_5
_CannotFlyHereText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " can't"
	db "<LINE>", "FLY here."
	db "<PROMPT>"

;@ path: data/text/text_5
_NotHealthyEnoughText::
	db TX_START, "Not healthy"
	db "<LINE>", "enough."
	db "<PROMPT>"

;@ path: data/text/text_5
_NewBadgeRequiredText::
	db TX_START, "No! A new BADGE"
	db "<LINE>", "is required."
	db "<PROMPT>"

;@ path: data/text/text_5
_CannotUseItemsHereText::
	db TX_START, "You can't use items"
	db "<LINE>", "here."
	db "<PROMPT>"

;@ path: data/text/text_5
_CannotGetOffHereText::
	db TX_START, "You can't get off"
	db "<LINE>", "here."
	db "<PROMPT>"

;@ path: data/text/text_5
_GotMonText::
	db TX_START, "<PLAYER> got"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_5
_SentToBoxText::
	db TX_START, "There's no more"
	db "<LINE>", "room for #MON!"
	db "<CONT>", "@"
	db TX_RAM
	dw wBoxMonNicks
	db TX_START, " was"
	db "<CONT>", "sent to #MON"
	db "<CONT>", "BOX @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, " on PC!"
	db "<DONE>"

;@ path: data/text/text_5
_BoxIsFullText::
	db TX_START, "There's no more"
	db "<LINE>", "room for #MON!"

	db "<PARA>", "The #MON BOX"
	db "<LINE>", "is full and can't"
	db "<CONT>", "accept any more!"

	db "<PARA>", "Change the BOX at"
	db "<LINE>", "a #MON CENTER!"
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownOakHeyWaitDontGoOutText::
	db TX_START, "OAK: Hey! Wait!"
	db "<LINE>", "Don't go out!@"
	db TX_END

;@ path: text/PalletTown
_PalletTownOakItsUnsafeText::
	db TX_START, "OAK: It's unsafe!"
	db "<LINE>", "Wild #MON live"
	db "<CONT>", "in tall grass!"

	db "<PARA>", "You need your own"
	db "<LINE>", "#MON for your"
	db "<CONT>", "protection."
	db "<CONT>", "I know!"

	db "<PARA>", "Here, come with"
	db "<LINE>", "me!"
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownGirlText::
	db TX_START, "I'm raising"
	db "<LINE>", "#MON too!"

	db "<PARA>", "When they get"
	db "<LINE>", "strong, they can"
	db "<CONT>", "protect me!"
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownFisherText::
	db TX_START, "Technology is"
	db "<LINE>", "incredible!"

	db "<PARA>", "You can now store"
	db "<LINE>", "and recall items"
	db "<CONT>", "and #MON as"
	db "<CONT>", "data via PC!"
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownOaksLabSignText::
	db TX_START, "OAK #MON"
	db "<LINE>", "RESEARCH LAB"
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownSignText::
	db TX_START, "PALLET TOWN"
	db "<LINE>", "Shades of your"
	db "<CONT>", "journey await!"
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownPlayersHouseSignText::
	db TX_START, "<PLAYER>'s house "
	db "<DONE>"

;@ path: text/PalletTown
_PalletTownRivalsHouseSignText::
	db TX_START, "<RIVAL>'s house "
	db "<DONE>"
;@ path: text/ViridianCity
_ViridianCityYoungster1Text::
	db TX_START, "Those # BALLs"
	db "<LINE>", "at your waist!"
	db "<CONT>", "You have #MON!"

	db "<PARA>", "It's great that"
	db "<LINE>", "you can carry and"
	db "<CONT>", "use #MON any"
	db "<CONT>", "time, anywhere!"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityGambler1GymAlwaysClosedText::
	db TX_START, "This #MON GYM"
	db "<LINE>", "is always closed."

	db "<PARA>", "I wonder who the"
	db "<LINE>", "LEADER is?"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityGambler1GymLeaderReturnedText::
	db TX_START, "VIRIDIAN GYM's"
	db "<LINE>", "LEADER returned!"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityYoungster2YouWantToKnowAboutText::
	db TX_START, "You want to know"
	db "<LINE>", "about the 2 kinds"
	db "<CONT>", "of caterpillar"
	db "<CONT>", "#MON?"
	db "<DONE>"

;@ path: text/ViridianCity
ViridianCityYoungster2OkThenText::
	db TX_START, "Oh, OK then!"
	db "<DONE>"

;@ path: text/ViridianCity
ViridianCityYoungster2CaterpieAndWeedleDescriptionText::
	db TX_START, "CATERPIE has no"
	db "<LINE>", "poison, but"
	db "<CONT>", "WEEDLE does."

	db "<PARA>", "Watch out for its"
	db "<LINE>", "POISON STING!"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityGirlHasntHadHisCoffeeYetText::
	db TX_START, "Oh Grandpa! Don't"
	db "<LINE>", "be so mean!"
	db "<CONT>", "He hasn't had his"
	db "<CONT>", "coffee yet."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityGirlWhenIGoShopText::
	db TX_START, "When I go shop in"
	db "<LINE>", "PEWTER CITY, I"
	db "<CONT>", "have to take the"
	db "<CONT>", "winding trail in"
	db "<CONT>", "VIRIDIAN FOREST."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityOldManSleepyPrivatePropertyText::
	db TX_START, "You can't go"
	db "<LINE>", "through here!"

	db "<PARA>", "This is private"
	db "<LINE>", "property!"
	db "<DONE>"

;@ path: text/ViridianCity
ViridianCityFisherYouCanHaveThisText::
	db TX_START, "Yawn!"
	db "<LINE>", "I must have dozed"
	db "<CONT>", "off in the sun."

	db "<PARA>", "I had this dream"
	db "<LINE>", "about a DROWZEE"
	db "<CONT>", "eating my dream."
	db "<CONT>", "What's this?"
	db "<CONT>", "Where did this TM"
	db "<CONT>", "come from?"

	db "<PARA>", "This is spooky!"
	db "<LINE>", "Here, you can"
	db "<CONT>", "have this TM."
	db "<PROMPT>"

;@ path: text/ViridianCity
_ViridianCityFisherReceivedTM42Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "TM42!@"
	db TX_END

;@ path: text/ViridianCity
_ViridianCityFisherTM42ExplanationText::
	db TX_START, "TM42 contains"
	db "<LINE>", "DREAM EATER..."
	db "<CONT>", "...Snore..."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityFisherTM42NoRoomText::
	db TX_START, "You have too much"
	db "<LINE>", "stuff already."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityOldManHadMyCoffeeNowText::
	db TX_START, "Ahh, I've had my"
	db "<LINE>", "coffee now and I"
	db "<CONT>", "feel great!"

	db "<PARA>", "Sure you can go"
	db "<LINE>", "through!"

	db "<PARA>", "Are you in a"
	db "<LINE>", "hurry?"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityOldManKnowHowToCatchPokemonText::
	db TX_START, "I see you're using"
	db "<LINE>", "a #DEX."

	db "<PARA>", "When you catch a"
	db "<LINE>", "#MON, #DEX"
	db "<CONT>", "is automatically"
	db "<CONT>", "updated."

	db "<PARA>", "What? Don't you"
	db "<LINE>", "know how to catch"
	db "<CONT>", "#MON?"

	db "<PARA>", "I'll show you"
	db "<LINE>", "how to then."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityOldManTimeIsMoneyText::
	db TX_START, "Time is money..."
	db "<LINE>", "Go along then."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityOldManYouNeedToWeakenTheTargetText::
	db TX_START, "First, you need"
	db "<LINE>", "to weaken the"
	db "<CONT>", "target #MON."
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCitySignText::
	db TX_START, "VIRIDIAN CITY "
	db "<LINE>", "The Eternally"
	db "<CONT>", "Green Paradise"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityTrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Catch #MON"
	db "<LINE>", "and expand your"
	db "<CONT>", "collection!"

	db "<PARA>", "The more you have,"
	db "<LINE>", "the easier it is"
	db "<CONT>", "to fight!"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityTrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "The battle moves"
	db "<LINE>", "of #MON are"
	db "<CONT>", "limited by their"
	db "<CONT>", "POWER POINTs, PP."

	db "<PARA>", "To replenish PP,"
	db "<LINE>", "rest your tired"
	db "<CONT>", "#MON at a"
	db "<CONT>", "#MON CENTER!"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityGymSignText::
	db TX_START, "VIRIDIAN CITY"
	db "<LINE>", "#MON GYM"
	db "<DONE>"

;@ path: text/ViridianCity
_ViridianCityGymLockedText::
	db TX_START, "The GYM's doors"
	db "<LINE>", "are locked..."
	db "<DONE>"
;@ path: text/PewterCity
_PewterCityCooltrainerFText::
	db TX_START, "It's rumored that"
	db "<LINE>", "CLEFAIRYs came"
	db "<CONT>", "from the moon!"

	db "<PARA>", "They appeared "
	db "<LINE>", "after MOON STONE"
	db "<CONT>", "fell on MT.MOON."
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityCooltrainerMText::
	db TX_START, "There aren't many"
	db "<LINE>", "serious #MON"
	db "<CONT>", "trainers here!"

	db "<PARA>", "They're all like"
	db "<LINE>", "BUG CATCHERs,"
	db "<CONT>", "but PEWTER GYM's"
	db "<CONT>", "BROCK is totally"
	db "<CONT>", "into it!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd1DidYouCheckOutMuseumText::
	db TX_START, "Did you check out"
	db "<LINE>", "the MUSEUM?"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd1WerentThoseFossilsAmazingText::
	db TX_START, "Weren't those"
	db "<LINE>", "fossils from MT."
	db "<CONT>", "MOON amazing?"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd1YouHaveToGoText::
	db TX_START, "Really?"
	db "<LINE>", "You absolutely"
	db "<CONT>", "have to go!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd1ItsRightHereText::
	db TX_START, "It's right here!"
	db "<LINE>", "You have to pay"
	db "<CONT>", "to get in, but"
	db "<CONT>", "it's worth it!"
	db "<CONT>", "See you around!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd2DoYouKnowWhatImDoingText::
	db TX_START, "Psssst!"
	db "<LINE>", "Do you know what"
	db "<CONT>", "I'm doing?"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd2ThatsRightText::
	db TX_START, "That's right!"
	db "<LINE>", "It's hard work!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySuperNerd2ImSprayingRepelText::
	db TX_START, "I'm spraying REPEL"
	db "<LINE>", "to keep #MON"
	db "<CONT>", "out of my garden!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityYoungsterYoureATrainerFollowMeText::
	db TX_START, "You're a trainer"
	db "<LINE>", "right? BROCK's"
	db "<CONT>", "looking for new"
	db "<CONT>", "challengers!"
	db "<CONT>", "Follow me!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityYoungsterGoTakeOnBrockText::
	db TX_START, "If you have the"
	db "<LINE>", "right stuff, go"
	db "<CONT>", "take on BROCK!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityTrainerTipsText::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Any #MON that"
	db "<LINE>", "takes part in"
	db "<CONT>", "battle, however"
	db "<CONT>", "short, earns EXP!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityPoliceNoticeSignText::
	db TX_START, "NOTICE!"

	db "<PARA>", "Thieves have been"
	db "<LINE>", "stealing #MON"
	db "<CONT>", "fossils at MT."
	db "<CONT>", "MOON! Please call"
	db "<CONT>", "PEWTER POLICE"
	db "<CONT>", "with any info!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityMuseumSignText::
	db TX_START, "PEWTER MUSEUM"
	db "<LINE>", "OF SCIENCE"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCityGymSignText::
	db TX_START, "PEWTER CITY"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: BROCK"

	db "<PARA>", "The Rock Solid"
	db "<LINE>", "#MON Trainer!"
	db "<DONE>"

;@ path: text/PewterCity
_PewterCitySignText::
	db TX_START, "PEWTER CITY"
	db "<LINE>", "A Stone Gray"
	db "<CONT>", "City"
	db "<DONE>"
;@ path: text/CeruleanCity
_CeruleanCityRivalPreBattleText::
	db TX_START, "<RIVAL>: Yo!"
	db "<LINE>", "<PLAYER>!"

	db "<PARA>", "You're still"
	db "<LINE>", "struggling along"
	db "<CONT>", "back here?"

	db "<PARA>", "I'm doing great!"
	db "<LINE>", "I caught a bunch"
	db "<CONT>", "of strong and"
	db "<CONT>", "smart #MON!"

	db "<PARA>", "Here, let me see"
	db "<LINE>", "what you caught,"
	db "<CONT>", "<PLAYER>!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityRivalDefeatedText::
	db TX_START, "Hey!"
	db "<LINE>", "Take it easy!"
	db "<CONT>", "You won already!"
	db "<PROMPT>"

;@ path: text/CeruleanCity
_CeruleanCityRivalVictoryText::
	db TX_START, "Heh!"
	db "<LINE>", "You're no match"
	db "<CONT>", "for my genius!"
	db "<PROMPT>"

;@ path: text/CeruleanCity
_CeruleanCityRivalIWentToBillsText::
	db TX_START, "<RIVAL>: Hey,"
	db "<LINE>", "guess what?"

	db "<PARA>", "I went to BILL's"
	db "<LINE>", "and got him to"
	db "<CONT>", "show me his rare"
	db "<CONT>", "#MON!"

	db "<PARA>", "That added a lot"
	db "<LINE>", "of pages to my"
	db "<CONT>", "#DEX!"

	db "<PARA>", "After all, BILL's"
	db "<LINE>", "world famous as a"
	db "<CONT>", "#MANIAC!"

	db "<PARA>", "He invented the"
	db "<LINE>", "#MON Storage"
	db "<CONT>", "System on PC!"

	db "<PARA>", "Since you're using"
	db "<LINE>", "his system, go"
	db "<CONT>", "thank him!"

	db "<PARA>", "Well, I better"
	db "<LINE>", "get rolling!"
	db "<CONT>", "Smell ya later!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityRocketText::
	db TX_START, "Hey! Stay out!"
	db "<LINE>", "It's not your"
	db "<CONT>", "yard! Huh? Me?"

	db "<PARA>", "I'm an innocent"
	db "<LINE>", "bystander! Don't"
	db "<CONT>", "you believe me?"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityRocketReceivedTM28Text::
	db TX_START, "<PLAYER> recovered"
	db "<LINE>", "TM28!@"
	db TX_END

;@ path: text/CeruleanCity
_CeruleanCityRocketIBetterGetMovingText::
	db TX_START

	db "<PARA>", "I better get"
	db "<LINE>", "moving! Bye!@"
	db TX_END

;@ path: text/CeruleanCity
_CeruleanCityRocketTM28NoRoomText::
	db TX_START, "Make room for"
	db "<LINE>", "this!"

	db "<PARA>", "I can't run until"
	db "<LINE>", "I give it to you!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityRocketIGiveUpText::
	db TX_START, "Stop!"
	db "<LINE>", "I give up! I'll"
	db "<CONT>", "leave quietly!"
	db "<PROMPT>"

;@ path: text/CeruleanCity
_CeruleanCityRocketIllReturnTheTMText::
	db TX_START, "OK! I'll return"
	db "<LINE>", "the TM I stole!"
	db "<PROMPT>"

;@ path: text/CeruleanCity
_CeruleanCityCooltrainerMText::
	db TX_START, "You're a trainer"
	db "<LINE>", "too? Collecting,"
	db "<CONT>", "fighting, it's a"
	db "<CONT>", "tough life."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySuperNerd1Text::
	db TX_START, "That bush in"
	db "<LINE>", "front of the shop"
	db "<CONT>", "is in the way."

	db "<PARA>", "There might be a"
	db "<LINE>", "way around."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySuperNerd2Text::
	db TX_START, "You're making an"
	db "<LINE>", "encyclopedia on"
	db "<CONT>", "#MON? That"
	db "<CONT>", "sounds amusing."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityGuardText::
	db TX_START, "The people here"
	db "<LINE>", "were robbed."

	db "<PARA>", "It's obvious that"
	db "<LINE>", "TEAM ROCKET is"
	db "<CONT>", "behind this most"
	db "<CONT>", "heinous crime!"

	db "<PARA>", "Even our POLICE"
	db "<LINE>", "force has trouble"
	db "<CONT>", "with the ROCKETs!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityCooltrainerF1SlowbroUseSonicboomText::
	db TX_START, "OK! SLOWBRO!"
	db "<LINE>", "Use SONICBOOM!"
	db "<CONT>", "Come on, SLOWBRO"
	db "<CONT>", "pay attention!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityCooltrainerF1SlowbroPunchText::
	db TX_START, "SLOWBRO punch!"
	db "<LINE>", "No! You blew it"
	db "<CONT>", "again!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityCooltrainerF1SlowbroWithdrawText::
	db TX_START, "SLOWBRO, WITHDRAW!"
	db "<LINE>", "No! That's wrong!"

	db "<PARA>", "It's so hard to"
	db "<LINE>", "control #MON!"

	db "<PARA>", "Your #MON's"
	db "<LINE>", "obedience depends"
	db "<CONT>", "on your abilities"
	db "<CONT>", "as a trainer!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySlowbroTookASnoozeText::
	db TX_START, "SLOWBRO took a"
	db "<LINE>", "snooze..."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySlowbroIsLoafingAroundText::
	db TX_START, "SLOWBRO is"
	db "<LINE>", "loafing around..."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySlowbroTurnedAwayText::
	db TX_START, "SLOWBRO turned"
	db "<LINE>", "away..."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySlowbroIgnoredOrdersText::
	db TX_START, "SLOWBRO"
	db "<LINE>", "ignored orders..."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityCooltrainerF2Text::
	db TX_START, "I want a bright"
	db "<LINE>", "red BICYCLE!"

	db "<PARA>", "I'll keep it at"
	db "<LINE>", "home, so it won't"
	db "<CONT>", "get dirty!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySuperNerd3Text::
	db TX_START, "This is CERULEAN"
	db "<LINE>", "CAVE! Horribly"
	db "<CONT>", "strong #MON"
	db "<CONT>", "live in there!"

	db "<PARA>", "The #MON LEAGUE"
	db "<LINE>", "champion is the"
	db "<CONT>", "only person who"
	db "<CONT>", "is allowed in!"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCitySignText::
	db TX_START, "CERULEAN CITY"
	db "<LINE>", "A Mysterious,"
	db "<CONT>", "Blue Aura"
	db "<CONT>", "Surrounds It"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityTrainerTipsText::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "Pressing B Button"
	db "<LINE>", "during evolution"
	db "<CONT>", "cancels the whole"
	db "<CONT>", "process."
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityBikeShopSign::
	db TX_START, "Grass and caves"
	db "<LINE>", "handled easily!"
	db "<CONT>", "BIKE SHOP"
	db "<DONE>"

;@ path: text/CeruleanCity
_CeruleanCityGymSign::
	db TX_START, "CERULEAN CITY"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: MISTY"

	db "<PARA>", "The Tomboyish"
	db "<LINE>", "Mermaid!"
	db "<DONE>"
;@ path: text/LavenderTown
_LavenderTownLittleGirlDoYouBelieveInGhostsText::
	db TX_START, "Do you believe in"
	db "<LINE>", "GHOSTs?"
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownLittleGirlSoThereAreBelieversText::
	db TX_START, "Really? So there"
	db "<LINE>", "are believers..."
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownLittleGirlHaHaGuessNotText::
	db TX_START, "Hahaha, I guess"
	db "<LINE>", "not."

	db "<PARA>", "That white hand"
	db "<LINE>", "on your shoulder,"
	db "<CONT>", "it's not real."
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownCooltrainerMText::
	db TX_START, "This town is known"
	db "<LINE>", "as the grave site"
	db "<CONT>", "of #MON."

	db "<PARA>", "Memorial services"
	db "<LINE>", "are held in"
	db "<CONT>", "#MON TOWER."
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownSuperNerdText::
	db TX_START, "GHOSTs appeared"
	db "<LINE>", "in #MON TOWER."

	db "<PARA>", "I think they're"
	db "<LINE>", "the spirits of"
	db "<CONT>", "#MON that the"
	db "<CONT>", "ROCKETs killed."
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownSignText::
	db TX_START, "LAVENDER TOWN"
	db "<LINE>", "The Noble Purple"
	db "<CONT>", "Town"
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownSilphScopeSignText::
	db TX_START, "New SILPH SCOPE!"

	db "<PARA>", "Make the Invisible"
	db "<LINE>", "Plain to See!"

	db "<PARA>", "SILPH CO."
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownPokemonHouseSignText::
	db TX_START, "LAVENDER VOLUNTEER"
	db "<LINE>", "#MON HOUSE"
	db "<DONE>"

;@ path: text/LavenderTown
_LavenderTownPokemonTowerSignText::
	db TX_START, "May the Souls of"
	db "<LINE>", "#MON Rest Easy"
	db "<CONT>", "#MON TOWER"
	db "<DONE>"
;@ path: text/VermilionCity
_VermilionCityBeautyText::
	db TX_START, "We're careful"
	db "<LINE>", "about pollution!"

	db "<PARA>", "We've heard GRIMER"
	db "<LINE>", "multiplies in"
	db "<CONT>", "toxic sludge!"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityGambler1DidYouSeeText::
	db TX_START, "Did you see S.S."
	db "<LINE>", "ANNE moored in"
	db "<CONT>", "the harbor?"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityGambler1SSAnneDepartedText::
	db TX_START, "So, S.S.ANNE has"
	db "<LINE>", "departed!"

	db "<PARA>", "She'll be back in"
	db "<LINE>", "about a year."
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCitySailor1WelcomeToSSAnneText::
	db TX_START, "Welcome to S.S."
	db "<LINE>", "ANNE!"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCitySailor1DoYouHaveATicketText::
	db TX_START, "Welcome to S.S."
	db "<LINE>", "ANNE!"

	db "<PARA>", "Excuse me, do you"
	db "<LINE>", "have a ticket?"
	db "<PROMPT>"

;@ path: text/VermilionCity
_VermilionCitySailor1FlashedTicketText::
	db TX_START, "<PLAYER> flashed"
	db "<LINE>", "the S.S.TICKET!"

	db "<PARA>", "Great! Welcome to"
	db "<LINE>", "S.S.ANNE!"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCitySailor1YouNeedATicketText::
	db TX_START, "<PLAYER> doesn't"
	db "<LINE>", "have the needed"
	db "<CONT>", "S.S.TICKET."

	db "<PARA>", "Sorry!"

	db "<PARA>", "You need a ticket"
	db "<LINE>", "to get aboard."
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCitySailor1ShipSetSailText::
	db TX_START, "The ship set sail."
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityGambler2Text::
	db TX_START, "I'm putting up a"
	db "<LINE>", "building on this"
	db "<CONT>", "plot of land."

	db "<PARA>", "My #MON is"
	db "<LINE>", "tamping the land."
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityMachopText::
	db TX_START, "MACHOP: Guoh!"
	db "<LINE>", "Gogogoh!@"
	db TX_END

;@ path: text/VermilionCity
_VermilionCityMachopStompingTheLandFlatText::
	db TX_START

	db "<PARA>", "A MACHOP is"
	db "<LINE>", "stomping the land"
	db "<CONT>", "flat."
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCitySailor2Text::
	db TX_START, "S.S.ANNE is a"
	db "<LINE>", "famous luxury"
	db "<CONT>", "cruise ship."

	db "<PARA>", "We visit VERMILION"
	db "<LINE>", "once a year."
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCitySignText::
	db TX_START, "VERMILION CITY"
	db "<LINE>", "The Port of"
	db "<CONT>", "Exquisite Sunsets"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityNoticeSignText::
	db TX_START, "NOTICE!"

	db "<PARA>", "ROUTE 12 may be"
	db "<LINE>", "blocked off by a"
	db "<CONT>", "sleeping #MON."

	db "<PARA>", "Detour through"
	db "<LINE>", "ROCK TUNNEL to"
	db "<CONT>", "LAVENDER TOWN."

	db "<PARA>", "VERMILION POLICE"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityPokemonFanClubSignText::
	db TX_START, "#MON FAN CLUB"
	db "<LINE>", "All #MON fans"
	db "<CONT>", "welcome!"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityGymSignText::
	db TX_START, "VERMILION CITY"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: LT.SURGE"

	db "<PARA>", "The Lightning "
	db "<LINE>", "American!"
	db "<DONE>"

;@ path: text/VermilionCity
_VermilionCityHarborSignText::
	db TX_START, "VERMILION HARBOR"
	db "<DONE>"
;@ path: text/CeladonCity
_CeladonCityLittleGirlText::
	db TX_START, "I got my KOFFING"
	db "<LINE>", "in CINNABAR!"

	db "<PARA>", "It's nice, but it"
	db "<LINE>", "breathes poison"
	db "<CONT>", "when it's angry!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGramps1Text::
	db TX_START, "Heheh! This GYM"
	db "<LINE>", "is great! It's"
	db "<CONT>", "full of women!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGirlText::
	db TX_START, "The GAME CORNER"
	db "<LINE>", "is bad for our"
	db "<CONT>", "city's image!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGramps2Text::
	db TX_START, "Moan! I blew it"
	db "<LINE>", "all at the slots!"

	db "<PARA>", "I knew I should"
	db "<LINE>", "have cashed in my"
	db "<CONT>", "coins for prizes!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGramps3Text::
	db TX_START, "Hello, there!"

	db "<PARA>", "I've seen you,"
	db "<LINE>", "but I never had a"
	db "<CONT>", "chance to talk!"

	db "<PARA>", "Here's a gift for"
	db "<LINE>", "dropping by!"
	db "<PROMPT>"

;@ path: text/CeladonCity
_CeladonCityGramps3ReceivedTM41Text::
	db TX_START, "<PLAYER> received"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!@"
	db TX_END

;@ path: text/CeladonCity
_CeladonCityGramps3TM41ExplanationText::
	db TX_START, "TM41 teaches"
	db "<LINE>", "SOFTBOILED!"

	db "<PARA>", "Only one #MON"
	db "<LINE>", "can use it!"

	db "<PARA>", "That #MON is"
	db "<LINE>", "CHANSEY!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGramps3TM41NoRoomText::
	db TX_START, "Oh, your pack is"
	db "<LINE>", "full of items!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityFisherText::
	db TX_START, "This is my trusted"
	db "<LINE>", "pal, POLIWRATH!"

	db "<PARA>", "It evolved from"
	db "<LINE>", "POLIWHIRL when I"
	db "<CONT>", "used WATER STONE!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityPoliwrathText::
	db TX_START, "POLIWRATH: Ribi"
	db "<LINE>", "ribit!@"
	db TX_END

;@ path: text/CeladonCity
_CeladonCityRocket1Text::
	db TX_START, "What are you"
	db "<LINE>", "staring at?"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityRocket2Text::
	db TX_START, "Keep out of TEAM"
	db "<LINE>", "ROCKET's way!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityTrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "X ACCURACY boosts"
	db "<LINE>", "the accuracy of"
	db "<CONT>", "techniques!"

	db "<PARA>", "DIRE HIT jacks up"
	db "<LINE>", "the likelihood of"
	db "<CONT>", "critical hits!"

	db "<PARA>", "Get your items at"
	db "<LINE>", "CELADON DEPT."
	db "<CONT>", "STORE!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCitySignText::
	db TX_START, "CELADON CITY"
	db "<LINE>", "The City of"
	db "<CONT>", "Rainbow Dreams"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGymSignText::
	db TX_START, "CELADON CITY"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: ERIKA"

	db "<PARA>", "The Nature Loving"
	db "<LINE>", "Princess!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityMansionSignText::
	db TX_START, "CELADON MANSION"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityDeptStoreSignText::
	db TX_START, "Find what you"
	db "<LINE>", "need at CELADON"
	db "<CONT>", "DEPT. STORE!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityTrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "GUARD SPEC."
	db "<LINE>", "protects #MON"
	db "<CONT>", "against SPECIAL"
	db "<CONT>", "attacks such as"
	db "<CONT>", "fire and water!"

	db "<PARA>", "Get your items at"
	db "<LINE>", "CELADON DEPT."
	db "<CONT>", "STORE!"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityPrizeExchangeSignText::
	db TX_START, "Coins exchanged"
	db "<LINE>", "for prizes!"
	db "<CONT>", "PRIZE EXCHANGE"
	db "<DONE>"

;@ path: text/CeladonCity
_CeladonCityGameCornerSignText::
	db TX_START, "ROCKET GAME CORNER"
	db "<LINE>", "The playground"
	db "<CONT>", "for grown-ups!"
	db "<DONE>"
;@ path: text/FuchsiaCity
_FuchsiaCityYoungster1Text::
	db TX_START, "Did you try the"
	db "<LINE>", "SAFARI GAME? Some"
	db "<CONT>", "#MON can only"
	db "<CONT>", "be caught there."
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityGamblerText::
	db TX_START, "SAFARI ZONE has a"
	db "<LINE>", "zoo in front of"
	db "<CONT>", "the entrance."

	db "<PARA>", "Out back is the"
	db "<LINE>", "SAFARI GAME for"
	db "<CONT>", "catching #MON."
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityErikText::
	db TX_START, "ERIK: Where's"
	db "<LINE>", "SARA? I said I'd"
	db "<CONT>", "meet her here."
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityYoungster2Text::
	db TX_START, "That item ball in"
	db "<LINE>", "there is really a"
	db "<CONT>", "#MON."
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityPokemonText::
	db TX_START, "!"
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCitySignText::
	db TX_START, "FUCHSIA CITY"
	db "<LINE>", "Behold! It's"
	db "<CONT>", "Passion Pink!"
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCitySafariGameSignText::
	db TX_START, "SAFARI GAME"
	db "<LINE>", "#MON-U-CATCH!"
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityWardensHomeSignText::
	db TX_START, "SAFARI ZONE"
	db "<LINE>", "WARDEN's HOME"
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCitySafariZoneSignText::
	db TX_START, "#MON PARADISE"
	db "<LINE>", "SAFARI ZONE"
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityGymSignText::
	db TX_START, "FUCHSIA CITY"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: KOGA"

	db "<PARA>", "The Poisonous"
	db "<LINE>", "Ninja Master"
	db "<DONE>"

;@ path: text/FuchsiaCity
_FuchsiaCityChanseySignText::
	db TX_START, "Name: CHANSEY"

	db "<PARA>", "Catching one is"
	db "<LINE>", "all up to chance."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCityVoltorbSignText::
	db TX_START, "Name: VOLTORB"

	db "<PARA>", "The very image of"
	db "<LINE>", "a # BALL."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCityKangaskhanSignText::
	db TX_START, "Name: KANGASKHAN"

	db "<PARA>", "A maternal #MON"
	db "<LINE>", "that raises its"
	db "<CONT>", "young in a pouch"
	db "<CONT>", "on its belly."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCitySlowpokeSignText::
	db TX_START, "Name: SLOWPOKE"

	db "<PARA>", "Friendly and very"
	db "<LINE>", "slow moving."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCityLaprasSignText::
	db TX_START, "Name: LAPRAS"

	db "<PARA>", "A.K.A. the king"
	db "<LINE>", "of the seas."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCityFossilSignOmanyteText::
	db TX_START, "Name: OMANYTE"

	db "<PARA>", "A #MON that"
	db "<LINE>", "was resurrected"
	db "<CONT>", "from a fossil."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCityFossilSignKabutoText::
	db TX_START, "Name: KABUTO"

	db "<PARA>", "A #MON that"
	db "<LINE>", "was resurrected"
	db "<CONT>", "from a fossil."
	db "<PROMPT>"

;@ path: text/FuchsiaCity
_FuchsiaCityFossilSignUndeterminedText::
	db TX_START, "..."
	db "<DONE>"
;@ path: text/CinnabarIsland
_CinnabarIslandDoorIsLockedText::
	db TX_START, "The door is"
	db "<LINE>", "locked..."
	db "<DONE>"

;@ path: text/CinnabarIsland
_CinnabarIslandGirlText::
	db TX_START, "CINNABAR GYM's"
	db "<LINE>", "BLAINE is an odd"
	db "<CONT>", "man who has lived"
	db "<CONT>", "here for decades."
	db "<DONE>"

;@ path: text/CinnabarIsland
_CinnabarIslandGamblerText::
	db TX_START, "Scientists conduct"
	db "<LINE>", "experiments in"
	db "<CONT>", "the burned out"
	db "<CONT>", "building."
	db "<DONE>"

;@ path: text/CinnabarIsland
_CinnabarIslandSignText::
	db TX_START, "CINNABAR ISLAND"
	db "<LINE>", "The Fiery Town of"
	db "<CONT>", "Burning Desire"
	db "<DONE>"

;@ path: text/CinnabarIsland
_CinnabarIslandPokemonLabSignText::
	db TX_START, "#MON LAB"
	db "<DONE>"

;@ path: text/CinnabarIsland
_CinnabarIslandGymSignText::
	db TX_START, "CINNABAR ISLAND"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: BLAINE"

	db "<PARA>", "The Hot-Headed"
	db "<LINE>", "Quiz Master!"
	db "<DONE>"
;@ path: text/SaffronCity
_SaffronCityRocket1Text::
	db TX_START, "What do you want?"
	db "<LINE>", "Get lost!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket2Text::
	db TX_START, "BOSS said he'll"
	db "<LINE>", "take this town!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket3Text::
	db TX_START, "Get out of the"
	db "<LINE>", "way!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket4Text::
	db TX_START, "SAFFRON belongs"
	db "<LINE>", "to TEAM ROCKET!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket5Text::
	db TX_START, "Being evil makes"
	db "<LINE>", "me feel so alive!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket6Text::
	db TX_START, "Ow! Watch where"
	db "<LINE>", "you're walking!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket7Text::
	db TX_START, "With SILPH under"
	db "<LINE>", "control, we can"
	db "<CONT>", "exploit #MON"
	db "<CONT>", "around the world!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityScientistText::
	db TX_START, "You beat TEAM"
	db "<LINE>", "ROCKET all alone?"
	db "<CONT>", "That's amazing!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCitySilphWorkerMText::
	db TX_START, "Yeah! TEAM ROCKET"
	db "<LINE>", "is gone!"
	db "<CONT>", "It's safe to go"
	db "<CONT>", "out again!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCitySilphWorkerFText::
	db TX_START, "People should be"
	db "<LINE>", "flocking back to"
	db "<CONT>", "SAFFRON now."
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityGentlemanText::
	db TX_START, "I flew here on my"
	db "<LINE>", "PIDGEOT when I"
	db "<CONT>", "read about SILPH."

	db "<PARA>", "It's already over?"
	db "<LINE>", "I missed the"
	db "<CONT>", "media action."
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityPidgeotText::
	db TX_START, "PIDGEOT: Bi bibii!@"
	db TX_END

;@ path: text/SaffronCity
_SaffronCityRockerText::
	db TX_START, "I saw ROCKET"
	db "<LINE>", "BOSS escaping"
	db "<CONT>", "SILPH's building."
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket8Text::
	db TX_START, "I'm a security"
	db "<LINE>", "guard."

	db "<PARA>", "Suspicious kids I"
	db "<LINE>", "don't allow in!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityRocket9Text::
	db TX_START, "..."
	db "<LINE>", "Snore..."

	db "<PARA>", "Hah! He's taking"
	db "<LINE>", "a snooze!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCitySignText::
	db TX_START, "SAFFRON CITY"
	db "<LINE>", "Shining, Golden"
	db "<CONT>", "Land of Commerce"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityFightingDojoSignText::
	db TX_START, "FIGHTING DOJO"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityGymSignText::
	db TX_START, "SAFFRON CITY"
	db "<LINE>", "#MON GYM"
	db "<CONT>", "LEADER: SABRINA"

	db "<PARA>", "The Master of"
	db "<LINE>", "Psychic #MON!"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityTrainerTips1Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "FULL HEAL cures"
	db "<LINE>", "all ailments like"
	db "<CONT>", "sleep and burns."

	db "<PARA>", "It costs a bit"
	db "<LINE>", "more, but it's"
	db "<CONT>", "more convenient."
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityTrainerTips2Text::
	db TX_START, "TRAINER TIPS"

	db "<PARA>", "New GREAT BALL"
	db "<LINE>", "offers improved"
	db "<CONT>", "capture rates."

	db "<PARA>", "Try it on those"
	db "<LINE>", "hard-to-catch"
	db "<CONT>", "#MON."
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCitySilphCoSignText::
	db TX_START, "SILPH CO."
	db "<LINE>", "OFFICE BUILDING"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCityMrPsychicsHouseSignText::
	db TX_START, "MR.PSYCHIC's"
	db "<LINE>", "HOUSE"
	db "<DONE>"

;@ path: text/SaffronCity
_SaffronCitySilphCoLatestProductSignText::
	db TX_START, "SILPH's latest"
	db "<LINE>", "product!"

	db "<PARA>", "Release to be"
	db "<LINE>", "determined..."
	db "<DONE>"

;@ path: data/text/text_6
_ItemUseBallText00::
	db TX_START, "It dodged the"
	db "<LINE>", "thrown BALL!"

	db "<PARA>", "This #MON"
	db "<LINE>", "can't be caught!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText01::
	db TX_START, "You missed the"
	db "<LINE>", "#MON!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText02::
	db TX_START, "Darn! The #MON"
	db "<LINE>", "broke free!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText03::
	db TX_START, "Aww! It appeared"
	db "<LINE>", "to be caught! "
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText04::
	db TX_START, "Shoot! It was so"
	db "<LINE>", "close too!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText05::
	db TX_START, "All right!"
	db "<LINE>", "@"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START, " was"
	db "<CONT>", "caught!@"
	db TX_END

;@ path: data/text/text_6
_ItemUseBallText07::
	db TX_RAM
	dw wBoxMonNicks
	db TX_START, " was"
	db "<LINE>", "transferred to"
	db "<CONT>", "BILL's PC!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText08::
	db TX_RAM
	dw wBoxMonNicks
	db TX_START, " was"
	db "<LINE>", "transferred to"
	db "<CONT>", "someone's PC!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseBallText06::
	db TX_START, "New #DEX data"
	db "<LINE>", "will be added for"
	db "<CONT>", "@"
	db TX_RAM
	dw wEnemyMonNick
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_6
_SurfingGotOnText::
	db TX_START, "<PLAYER> got on"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_6
_SurfingNoPlaceToGetOffText::
	db TX_START, "There's no place"
	db "<LINE>", "to get off!"
	db "<PROMPT>"

;@ path: data/text/text_6
_VitaminStatRoseText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, "'s"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, " rose."
	db "<PROMPT>"

;@ path: data/text/text_6
_VitaminNoEffectText::
	db TX_START, "It won't have any"
	db "<LINE>", "effect."
	db "<PROMPT>"

;@ path: data/text/text_6
_ThrewBaitText::
	db TX_START, "<PLAYER> threw"
	db "<LINE>", "some BAIT."
	db "<DONE>"

;@ path: data/text/text_6
_ThrewRockText::
	db TX_START, "<PLAYER> threw a"
	db "<LINE>", "ROCK."
	db "<DONE>"

;@ path: data/text/text_6
_PlayedFluteNoEffectText::
	db TX_START, "Played the #"
	db "<LINE>", "FLUTE."

	db "<PARA>", "Now, that's a"
	db "<LINE>", "catchy tune!"
	db "<PROMPT>"

;@ path: data/text/text_6
_FluteWokeUpText::
	db TX_START, "All sleeping"
	db "<LINE>", "#MON woke up."
	db "<PROMPT>"

;@ path: data/text/text_6
_PlayedFluteHadEffectText::
	db TX_START, "<PLAYER> played the"
	db "<LINE>", "# FLUTE.@"
	db TX_END

;@ path: data/text/text_6
_CoinCaseNumCoinsText::
	db TX_START, "Coins"
	db "<LINE>", "@"
	db TX_BCD
	dw wPlayerCoins
	db 2 | LEADING_ZEROES | LEFT_ALIGN
	db TX_START, " "
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemfinderFoundItemText::
	db TX_START, "Yes! ITEMFINDER"
	db "<LINE>", "indicates there's"
	db "<CONT>", "an item nearby."
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemfinderFoundNothingText::
	db TX_START, "Nope! ITEMFINDER"
	db "<LINE>", "isn't responding."
	db "<PROMPT>"

;@ path: data/text/text_6
_RaisePPWhichTechniqueText::
	db TX_START, "Raise PP of which"
	db "<LINE>", "technique?"
	db "<DONE>"

;@ path: data/text/text_6
_RestorePPWhichTechniqueText::
	db TX_START, "Restore PP of"
	db "<LINE>", "which technique?"
	db "<DONE>"

;@ path: data/text/text_6
_PPMaxedOutText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, "'s PP"
	db "<LINE>", "is maxed out."
	db "<PROMPT>"

;@ path: data/text/text_6
_PPIncreasedText::
	db TX_RAM
	dw wStringBuffer
	db TX_START, "'s PP"
	db "<LINE>", "increased."
	db "<PROMPT>"

;@ path: data/text/text_6
_PPRestoredText::
	db TX_START, "PP was restored."
	db "<PROMPT>"

;@ path: data/text/text_6
_BootedUpTMText::
	db TX_START, "Booted up a TM!"
	db "<PROMPT>"

;@ path: data/text/text_6
_BootedUpHMText::
	db TX_START, "Booted up an HM!"
	db "<PROMPT>"

;@ path: data/text/text_6
_TeachMachineMoveText::
	db TX_START, "It contained"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"

	db "<PARA>", "Teach @"
	db TX_RAM
	dw wStringBuffer
	db TX_START
	db "<LINE>", "to a #MON?"
	db "<DONE>"

;@ path: data/text/text_6
_MonCannotLearnMachineMoveText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " is not"
	db "<LINE>", "compatible with"
	db "<CONT>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "."

	db "<PARA>", "It can't learn"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "."
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseNotTimeText::
	db TX_START, "OAK: <PLAYER>!"
	db "<LINE>", "This isn't the"
	db "<CONT>", "time to use that! "
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseNotYoursToUseText::
	db TX_START, "This isn't yours"
	db "<LINE>", "to use!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ItemUseNoEffectText::
	db TX_START, "It won't have any"
	db "<LINE>", "effect."
	db "<PROMPT>"

;@ path: data/text/text_6
_ThrowBallAtTrainerMonText1::
	db TX_START, "The trainer"
	db "<LINE>", "blocked the BALL!"
	db "<PROMPT>"

;@ path: data/text/text_6
_ThrowBallAtTrainerMonText2::
	db TX_START, "Don't be a thief!"
	db "<PROMPT>"

;@ path: data/text/text_6
_NoCyclingAllowedHereText::
	db TX_START, "No cycling"
	db "<NEXT>", "allowed here."
	db "<PROMPT>"

;@ path: data/text/text_6
_NoSurfingHereText::
	db TX_START, "No SURFing on"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, " here!"
	db "<PROMPT>"

;@ path: data/text/text_6
_BoxFullCannotThrowBallText::
	db TX_START, "The #MON BOX"
	db "<LINE>", "is full! Can't"
	db "<CONT>", "use that item!"
	db "<PROMPT>"


SECTION "Text 11", ROMX

;@ path: data/text/text_7
_ItemUseText001::
	db TX_START, "<PLAYER> used@"
	db TX_END

;@ path: data/text/text_7
_ItemUseText002::
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"
	db "<DONE>"

;@ path: data/text/text_7
_GotOnBicycleText1::
	db TX_START, "<PLAYER> got on the@"
	db TX_END

;@ path: data/text/text_7
_GotOnBicycleText2::
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_7
_GotOffBicycleText1::
	db TX_START, "<PLAYER> got off@"
	db TX_END

;@ path: data/text/text_7
_GotOffBicycleText2::
	db TX_START, "the @"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "."
	db "<PROMPT>"

;@ path: data/text/text_7
_ThrewAwayItemText::
	db TX_START, "Threw away"
	db "<LINE>", "@"
	db TX_RAM
	dw wNameBuffer
	db TX_START, "."
	db "<PROMPT>"

;@ path: data/text/text_7
_IsItOKToTossItemText::
	db TX_START, "Is it OK to toss"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "?"
	db "<PROMPT>"

;@ path: data/text/text_7
_TooImportantToTossText::
	db TX_START, "That's too impor-"
	db "<LINE>", "tant to toss!"
	db "<PROMPT>"

;@ path: data/text/text_7
_AlreadyKnowsText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " knows"
	db "<LINE>", "@"
	db TX_RAM
	dw wStringBuffer
	db TX_START, "!"
	db "<PROMPT>"

;@ path: data/text/text_7
_ConnectCableText::
	db TX_START, "Okay, connect the"
	db "<LINE>", "cable like so!"
	db "<PROMPT>"

;@ path: data/text/text_7
_TradedForText::
	db TX_START, "<PLAYER> traded"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, " for"
	db "<CONT>", "@"
	db TX_RAM
	dw wInGameTradeReceiveMonName
	db TX_START, "!@"
	db TX_END

;@ path: data/text/text_7
_WannaTrade1Text::
	db TX_START, "I'm looking for"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, "! Wanna"

	db "<PARA>", "trade one for"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeReceiveMonName
	db TX_START, "? "
	db "<DONE>"

;@ path: data/text/text_7
_NoTrade1Text::
	db TX_START, "Awww!"
	db "<LINE>", "Oh well..."
	db "<DONE>"

;@ path: data/text/text_7
_WrongMon1Text::
	db TX_START, "What? That's not"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, "!"

	db "<PARA>", "If you get one,"
	db "<LINE>", "come back here!"
	db "<DONE>"

;@ path: data/text/text_7
_Thanks1Text::
	db TX_START, "Hey thanks!"
	db "<DONE>"

;@ path: data/text/text_7
_AfterTrade1Text::
	db TX_START, "Isn't my old"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeReceiveMonName
	db TX_START, " great?"
	db "<DONE>"

;@ path: data/text/text_7
_WannaTrade2Text::
	db TX_START, "Hello there! Do"
	db "<LINE>", "you want to trade"

	db "<PARA>", "your @"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START
	db "<LINE>", "for @"
	db TX_RAM
	dw wInGameTradeReceiveMonName
	db TX_START, "?"
	db "<DONE>"

;@ path: data/text/text_7
_NoTrade2Text::
	db TX_START, "Well, if you"
	db "<LINE>", "don't want to..."
	db "<DONE>"

;@ path: data/text/text_7
_WrongMon2Text::
	db TX_START, "Hmmm? This isn't"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, "."

	db "<PARA>", "Think of me when"
	db "<LINE>", "you get one."
	db "<DONE>"

;@ path: data/text/text_7
_Thanks2Text::
	db TX_START, "Thanks!"
	db "<DONE>"

;@ path: data/text/text_7
_AfterTrade2Text::
	db TX_START, "The @"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, " you"
	db "<LINE>", "traded to me"

	db "<PARA>", "went and evolved!"
	db "<DONE>"

;@ path: data/text/text_7
_WannaTrade3Text::
	db TX_START, "Hi! Do you have"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, "?"

	db "<PARA>", "Want to trade it"
	db "<LINE>", "for @"
	db TX_RAM
	dw wInGameTradeReceiveMonName
	db TX_START, "?"
	db "<DONE>"

;@ path: data/text/text_7
_NoTrade3Text::
	db TX_START, "That's too bad."
	db "<DONE>"

;@ path: data/text/text_7
_WrongMon3Text::
	db TX_START, "...This is no"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, "."

	db "<PARA>", "If you get one,"
	db "<LINE>", "trade it with me!"
	db "<DONE>"

;@ path: data/text/text_7
_Thanks3Text::
	db TX_START, "Thanks pal!"
	db "<DONE>"

;@ path: data/text/text_7
_AfterTrade3Text::
	db TX_START, "How is my old"
	db "<LINE>", "@"
	db TX_RAM
	dw wInGameTradeReceiveMonName
	db TX_START, "?"

	db "<PARA>", "My @"
	db TX_RAM
	dw wInGameTradeGiveMonName
	db TX_START, " is"
	db "<LINE>", "doing great!"
	db "<DONE>"

;@ path: data/text/text_7
_NothingToCutText::
	db TX_START, "There isn't"
	db "<LINE>", "anything to CUT!"
	db "<PROMPT>"

;@ path: data/text/text_7
_UsedCutText::
	db TX_RAM
	dw wNameBuffer
	db TX_START, " hacked"
	db "<LINE>", "away with CUT!"
	db "<PROMPT>"


SECTION "Pokédex Text", ROMX

;@ path: data/pokemon/dex_text
_RhydonDexEntry::
	db TX_START, "Protected by an"
	db "<NEXT>", "armor-like hide,"
	db "<NEXT>", "it is capable of"

	db "<PAGE>", "living in molten"
	db "<NEXT>", "lava of 3,600"
	db "<NEXT>", "degrees"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KangaskhanDexEntry::
	db TX_START, "The infant rarely"
	db "<NEXT>", "ventures out of"
	db "<NEXT>", "its mother's"

	db "<PAGE>", "protective pouch"
	db "<NEXT>", "until it is 3"
	db "<NEXT>", "years old"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NidoranMDexEntry::
	db TX_START, "Stiffens its ears"
	db "<NEXT>", "to sense danger."
	db "<NEXT>", "The larger its"

	db "<PAGE>", "horns, the more"
	db "<NEXT>", "powerful its"
	db "<NEXT>", "secreted venom"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ClefairyDexEntry::
	db TX_START, "Its magical and"
	db "<NEXT>", "cute appeal has"
	db "<NEXT>", "many admirers."

	db "<PAGE>", "It is rare and"
	db "<NEXT>", "found only in"
	db "<NEXT>", "certain areas"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SpearowDexEntry::
	db TX_START, "Eats bugs in"
	db "<NEXT>", "grassy areas. It"
	db "<NEXT>", "has to flap its"

	db "<PAGE>", "short wings at"
	db "<NEXT>", "high speed to"
	db "<NEXT>", "stay airborne"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VoltorbDexEntry::
	db TX_START, "Usually found in"
	db "<NEXT>", "power plants."
	db "<NEXT>", "Easily mistaken"

	db "<PAGE>", "for a # BALL,"
	db "<NEXT>", "they have zapped"
	db "<NEXT>", "many people"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NidokingDexEntry::
	db TX_START, "It uses its"
	db "<NEXT>", "powerful tail in"
	db "<NEXT>", "battle to smash,"

	db "<PAGE>", "constrict, then"
	db "<NEXT>", "break the prey's"
	db "<NEXT>", "bones"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SlowbroDexEntry::
	db TX_START, "The SHELLDER that"
	db "<NEXT>", "is latched onto"
	db "<NEXT>", "SLOWPOKE's tail"

	db "<PAGE>", "is said to feed"
	db "<NEXT>", "on the host's left"
	db "<NEXT>", "over scraps"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_IvysaurDexEntry::
	db TX_START, "When the bulb on"
	db "<NEXT>", "its back grows"
	db "<NEXT>", "large, it appears"

	db "<PAGE>", "to lose the"
	db "<NEXT>", "ability to stand"
	db "<NEXT>", "on its hind legs"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ExeggutorDexEntry::
	db TX_START, "Legend has it that"
	db "<NEXT>", "on rare occasions,"
	db "<NEXT>", "one of its heads"

	db "<PAGE>", "will drop off and"
	db "<NEXT>", "continue on as an"
	db "<NEXT>", "EXEGGCUTE"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_LickitungDexEntry::
	db TX_START, "Its tongue can be"
	db "<NEXT>", "extended like a"
	db "<NEXT>", "chameleon's. It"

	db "<PAGE>", "leaves a tingling"
	db "<NEXT>", "sensation when it"
	db "<NEXT>", "licks enemies"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ExeggcuteDexEntry::
	db TX_START, "Often mistaken"
	db "<NEXT>", "for eggs."
	db "<NEXT>", "When disturbed,"

	db "<PAGE>", "they quickly"
	db "<NEXT>", "gather and attack"
	db "<NEXT>", "in swarms"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GrimerDexEntry::
	db TX_START, "Appears in filthy"
	db "<NEXT>", "areas. Thrives by"
	db "<NEXT>", "sucking up"

	db "<PAGE>", "polluted sludge"
	db "<NEXT>", "that is pumped"
	db "<NEXT>", "out of factories"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GengarDexEntry::
	db TX_START, "Under a full moon,"
	db "<NEXT>", "this #MON"
	db "<NEXT>", "likes to mimic"

	db "<PAGE>", "the shadows of"
	db "<NEXT>", "people and laugh"
	db "<NEXT>", "at their fright"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NidoranFDexEntry::
	db TX_START, "Although small,"
	db "<NEXT>", "its venomous"
	db "<NEXT>", "barbs render this"

	db "<PAGE>", "#MON dangerous."
	db "<NEXT>", "The female has"
	db "<NEXT>", "smaller horns"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NidoqueenDexEntry::
	db TX_START, "Its hard scales"
	db "<NEXT>", "provide strong"
	db "<NEXT>", "protection. It"

	db "<PAGE>", "uses its hefty"
	db "<NEXT>", "bulk to execute"
	db "<NEXT>", "powerful moves"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_CuboneDexEntry::
	db TX_START, "Because it never"
	db "<NEXT>", "removes its skull"
	db "<NEXT>", "helmet, no one"

	db "<PAGE>", "has ever seen"
	db "<NEXT>", "this #MON's"
	db "<NEXT>", "real face"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_RhyhornDexEntry::
	db TX_START, "Its massive bones"
	db "<NEXT>", "are 1000 times"
	db "<NEXT>", "harder than human"

	db "<PAGE>", "bones. It can"
	db "<NEXT>", "easily knock a"
	db "<NEXT>", "trailer flying"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_LaprasDexEntry::
	db TX_START, "A #MON that"
	db "<NEXT>", "has been over-"
	db "<NEXT>", "hunted almost to"

	db "<PAGE>", "extinction. It"
	db "<NEXT>", "can ferry people"
	db "<NEXT>", "across the water"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ArcanineDexEntry::
	db TX_START, "A #MON that"
	db "<NEXT>", "has been admired"
	db "<NEXT>", "since the past"

	db "<PAGE>", "for its beauty."
	db "<NEXT>", "It runs agilely"
	db "<NEXT>", "as if on wings"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MewDexEntry::
	db TX_START, "So rare that it"
	db "<NEXT>", "is still said to"
	db "<NEXT>", "be a mirage by"

	db "<PAGE>", "many experts. Only"
	db "<NEXT>", "a few people have"
	db "<NEXT>", "seen it worldwide"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GyaradosDexEntry::
	db TX_START, "Rarely seen in"
	db "<NEXT>", "the wild. Huge"
	db "<NEXT>", "and vicious, it"

	db "<PAGE>", "is capable of"
	db "<NEXT>", "destroying entire"
	db "<NEXT>", "cities in a rage"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ShellderDexEntry::
	db TX_START, "Its hard shell"
	db "<NEXT>", "repels any kind"
	db "<NEXT>", "of attack."

	db "<PAGE>", "It is vulnerable"
	db "<NEXT>", "only when its"
	db "<NEXT>", "shell is open"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_TentacoolDexEntry::
	db TX_START, "Drifts in shallow"
	db "<NEXT>", "seas. Anglers who"
	db "<NEXT>", "hook them by"

	db "<PAGE>", "accident are"
	db "<NEXT>", "often punished by"
	db "<NEXT>", "its stinging acid"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GastlyDexEntry::
	db TX_START, "Almost invisible,"
	db "<NEXT>", "this gaseous"
	db "<NEXT>", "#MON cloaks"

	db "<PAGE>", "the target and"
	db "<NEXT>", "puts it to sleep"
	db "<NEXT>", "without notice"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ScytherDexEntry::
	db TX_START, "With ninja-like"
	db "<NEXT>", "agility and speed,"
	db "<NEXT>", "it can create the"

	db "<PAGE>", "illusion that"
	db "<NEXT>", "there is more"
	db "<NEXT>", "than one"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_StaryuDexEntry::
	db TX_START, "An enigmatic"
	db "<NEXT>", "#MON that can"
	db "<NEXT>", "effortlessly"

	db "<PAGE>", "regenerate any"
	db "<NEXT>", "appendage it"
	db "<NEXT>", "loses in battle"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_BlastoiseDexEntry::
	db TX_START, "A brutal #MON"
	db "<NEXT>", "with pressurized"
	db "<NEXT>", "water jets on its"

	db "<PAGE>", "shell. They are"
	db "<NEXT>", "used for high"
	db "<NEXT>", "speed tackles"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PinsirDexEntry::
	db TX_START, "If it fails to"
	db "<NEXT>", "crush the victim"
	db "<NEXT>", "in its pincers,"

	db "<PAGE>", "it will swing it"
	db "<NEXT>", "around and toss"
	db "<NEXT>", "it hard"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_TangelaDexEntry::
	db TX_START, "The whole body is"
	db "<NEXT>", "swathed with wide"
	db "<NEXT>", "vines that are"

	db "<PAGE>", "similar to sea-"
	db "<NEXT>", "weed. Its vines"
	db "<NEXT>", "shake as it walks"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GrowlitheDexEntry::
	db TX_START, "Very protective"
	db "<NEXT>", "of its territory."
	db "<NEXT>", "It will bark and"

	db "<PAGE>", "bite to repel"
	db "<NEXT>", "intruders from"
	db "<NEXT>", "its space"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_OnixDexEntry::
	db TX_START, "As it grows, the"
	db "<NEXT>", "stone portions of"
	db "<NEXT>", "its body harden"

	db "<PAGE>", "to become similar"
	db "<NEXT>", "to a diamond, but"
	db "<NEXT>", "colored black"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_FearowDexEntry::
	db TX_START, "With its huge and"
	db "<NEXT>", "magnificent wings,"
	db "<NEXT>", "it can keep aloft"

	db "<PAGE>", "without ever"
	db "<NEXT>", "having to land"
	db "<NEXT>", "for rest"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PidgeyDexEntry::
	db TX_START, "A common sight in"
	db "<NEXT>", "forests and woods."
	db "<NEXT>", "It flaps its"

	db "<PAGE>", "wings at ground"
	db "<NEXT>", "level to kick up"
	db "<NEXT>", "blinding sand"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SlowpokeDexEntry::
	db TX_START, "Incredibly slow"
	db "<NEXT>", "and dopey. It"
	db "<NEXT>", "takes 5 seconds"

	db "<PAGE>", "for it to feel"
	db "<NEXT>", "pain when under"
	db "<NEXT>", "attack"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KadabraDexEntry::
	db TX_START, "It emits special"
	db "<NEXT>", "alpha waves from"
	db "<NEXT>", "its body that"

	db "<PAGE>", "induce headaches"
	db "<NEXT>", "just by being"
	db "<NEXT>", "close by"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GravelerDexEntry::
	db TX_START, "Rolls down slopes"
	db "<NEXT>", "to move. It rolls"
	db "<NEXT>", "over any obstacle"

	db "<PAGE>", "without slowing"
	db "<NEXT>", "or changing its"
	db "<NEXT>", "direction"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ChanseyDexEntry::
	db TX_START, "A rare and elusive"
	db "<NEXT>", "#MON that is"
	db "<NEXT>", "said to bring"

	db "<PAGE>", "happiness to those"
	db "<NEXT>", "who manage to get"
	db "<NEXT>", "it"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MachokeDexEntry::
	db TX_START, "Its muscular body"
	db "<NEXT>", "is so powerful, it"
	db "<NEXT>", "must wear a power"

	db "<PAGE>", "save belt to be"
	db "<NEXT>", "able to regulate"
	db "<NEXT>", "its motions"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MrMimeDexEntry::
	db TX_START, "If interrupted"
	db "<NEXT>", "while it is"
	db "<NEXT>", "miming, it will"

	db "<PAGE>", "slap around the"
	db "<NEXT>", "offender with its"
	db "<NEXT>", "broad hands"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_HitmonleeDexEntry::
	db TX_START, "When in a hurry,"
	db "<NEXT>", "its legs lengthen"
	db "<NEXT>", "progressively."

	db "<PAGE>", "It runs smoothly"
	db "<NEXT>", "with extra long,"
	db "<NEXT>", "loping strides"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_HitmonchanDexEntry::
	db TX_START, "While apparently"
	db "<NEXT>", "doing nothing, it"
	db "<NEXT>", "fires punches in"

	db "<PAGE>", "lightning fast"
	db "<NEXT>", "volleys that are"
	db "<NEXT>", "impossible to see"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ArbokDexEntry::
	db TX_START, "It is rumored that"
	db "<NEXT>", "the ferocious"
	db "<NEXT>", "warning markings"

	db "<PAGE>", "on its belly"
	db "<NEXT>", "differ from area"
	db "<NEXT>", "to area"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ParasectDexEntry::
	db TX_START, "A host-parasite"
	db "<NEXT>", "pair in which the"
	db "<NEXT>", "parasite mushroom"

	db "<PAGE>", "has taken over the"
	db "<NEXT>", "host bug. Prefers"
	db "<NEXT>", "damp places"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PsyduckDexEntry::
	db TX_START, "While lulling its"
	db "<NEXT>", "enemies with its"
	db "<NEXT>", "vacant look, this"

	db "<PAGE>", "wily #MON will"
	db "<NEXT>", "use psychokinetic"
	db "<NEXT>", "powers"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DrowzeeDexEntry::
	db TX_START, "Puts enemies to"
	db "<NEXT>", "sleep then eats"
	db "<NEXT>", "their dreams."

	db "<PAGE>", "Occasionally gets"
	db "<NEXT>", "sick from eating"
	db "<NEXT>", "bad dreams"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GolemDexEntry::
	db TX_START, "Its boulder-like"
	db "<NEXT>", "body is extremely"
	db "<NEXT>", "hard. It can"

	db "<PAGE>", "easily withstand"
	db "<NEXT>", "dynamite blasts"
	db "<NEXT>", "without damage"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MagmarDexEntry::
	db TX_START, "Its body always"
	db "<NEXT>", "burns with an"
	db "<NEXT>", "orange glow that"

	db "<PAGE>", "enables it to"
	db "<NEXT>", "hide perfectly"
	db "<NEXT>", "among flames"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ElectabuzzDexEntry::
	db TX_START, "Normally found"
	db "<NEXT>", "near power plants,"
	db "<NEXT>", "they can wander"

	db "<PAGE>", "away and cause"
	db "<NEXT>", "major blackouts"
	db "<NEXT>", "in cities"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MagnetonDexEntry::
	db TX_START, "Formed by several"
	db "<NEXT>", "MAGNEMITEs linked"
	db "<NEXT>", "together. They"

	db "<PAGE>", "frequently appear"
	db "<NEXT>", "when sunspots"
	db "<NEXT>", "flare up"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KoffingDexEntry::
	db TX_START, "Because it stores"
	db "<NEXT>", "several kinds of"
	db "<NEXT>", "toxic gases in"

	db "<PAGE>", "its body, it is"
	db "<NEXT>", "prone to exploding"
	db "<NEXT>", "without warning"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MankeyDexEntry::
	db TX_START, "Extremely quick to"
	db "<NEXT>", "anger. It could"
	db "<NEXT>", "be docile one"

	db "<PAGE>", "moment then"
	db "<NEXT>", "thrashing away"
	db "<NEXT>", "the next instant"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SeelDexEntry::
	db TX_START, "The protruding"
	db "<NEXT>", "horn on its head"
	db "<NEXT>", "is very hard."

	db "<PAGE>", "It is used for"
	db "<NEXT>", "bashing through"
	db "<NEXT>", "thick ice"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DiglettDexEntry::
	db TX_START, "Lives about one"
	db "<NEXT>", "yard underground"
	db "<NEXT>", "where it feeds on"

	db "<PAGE>", "plant roots. It"
	db "<NEXT>", "sometimes appears"
	db "<NEXT>", "above ground"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_TaurosDexEntry::
	db TX_START, "When it targets"
	db "<NEXT>", "an enemy, it"
	db "<NEXT>", "charges furiously"

	db "<PAGE>", "while whipping its"
	db "<NEXT>", "body with its"
	db "<NEXT>", "long tails"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_FarfetchdDexEntry::
	db TX_START, "The sprig of"
	db "<NEXT>", "green onions it"
	db "<NEXT>", "holds is its"

	db "<PAGE>", "weapon. It is"
	db "<NEXT>", "used much like a"
	db "<NEXT>", "metal sword"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VenonatDexEntry::
	db TX_START, "Lives in the"
	db "<NEXT>", "shadows of tall"
	db "<NEXT>", "trees where it"

	db "<PAGE>", "eats insects. It"
	db "<NEXT>", "is attracted by"
	db "<NEXT>", "light at night"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DragoniteDexEntry::
	db TX_START, "An extremely"
	db "<NEXT>", "rarely seen"
	db "<NEXT>", "marine #MON."

	db "<PAGE>", "Its intelligence"
	db "<NEXT>", "is said to match"
	db "<NEXT>", "that of humans"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DoduoDexEntry::
	db TX_START, "A bird that makes"
	db "<NEXT>", "up for its poor"
	db "<NEXT>", "flying with its"

	db "<PAGE>", "fast foot speed."
	db "<NEXT>", "Leaves giant"
	db "<NEXT>", "footprints"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PoliwagDexEntry::
	db TX_START, "Its newly grown"
	db "<NEXT>", "legs prevent it"
	db "<NEXT>", "from running. It"

	db "<PAGE>", "appears to prefer"
	db "<NEXT>", "swimming than"
	db "<NEXT>", "trying to stand"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_JynxDexEntry::
	db TX_START, "It seductively"
	db "<NEXT>", "wiggles its hips"
	db "<NEXT>", "as it walks. It"

	db "<PAGE>", "can cause people"
	db "<NEXT>", "to dance in"
	db "<NEXT>", "unison with it"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MoltresDexEntry::
	db TX_START, "Known as the"
	db "<NEXT>", "legendary bird of"
	db "<NEXT>", "fire. Every flap"

	db "<PAGE>", "of its wings"
	db "<NEXT>", "creates a dazzling"
	db "<NEXT>", "flash of flames"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ArticunoDexEntry::
	db TX_START, "A legendary bird"
	db "<NEXT>", "#MON that is"
	db "<NEXT>", "said to appear to"

	db "<PAGE>", "doomed people who"
	db "<NEXT>", "are lost in icy"
	db "<NEXT>", "mountains"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ZapdosDexEntry::
	db TX_START, "A legendary bird"
	db "<NEXT>", "#MON that is"
	db "<NEXT>", "said to appear"

	db "<PAGE>", "from clouds while"
	db "<NEXT>", "dropping enormous"
	db "<NEXT>", "lightning bolts"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DittoDexEntry::
	db TX_START, "Capable of copying"
	db "<NEXT>", "an enemy's genetic"
	db "<NEXT>", "code to instantly"

	db "<PAGE>", "transform itself"
	db "<NEXT>", "into a duplicate"
	db "<NEXT>", "of the enemy"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MeowthDexEntry::
	db TX_START, "Adores circular"
	db "<NEXT>", "objects. Wanders"
	db "<NEXT>", "the streets on a"

	db "<PAGE>", "nightly basis to"
	db "<NEXT>", "look for dropped"
	db "<NEXT>", "loose change"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KrabbyDexEntry::
	db TX_START, "Its pincers are"
	db "<NEXT>", "not only powerful"
	db "<NEXT>", "weapons, they are"

	db "<PAGE>", "used for balance"
	db "<NEXT>", "when walking"
	db "<NEXT>", "sideways"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VulpixDexEntry::
	db TX_START, "At the time of"
	db "<NEXT>", "birth, it has"
	db "<NEXT>", "just one tail."

	db "<PAGE>", "The tail splits"
	db "<NEXT>", "from its tip as"
	db "<NEXT>", "it grows older"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NinetalesDexEntry::
	db TX_START, "Very smart and"
	db "<NEXT>", "very vengeful."
	db "<NEXT>", "Grabbing one of"

	db "<PAGE>", "its many tails"
	db "<NEXT>", "could result in a"
	db "<NEXT>", "1000-year curse"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PikachuDexEntry::
	db TX_START, "When several of"
	db "<NEXT>", "these #MON"
	db "<NEXT>", "gather, their"

	db "<PAGE>", "electricity could"
	db "<NEXT>", "build and cause"
	db "<NEXT>", "lightning storms"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_RaichuDexEntry::
	db TX_START, "Its long tail"
	db "<NEXT>", "serves as a"
	db "<NEXT>", "ground to protect"

	db "<PAGE>", "itself from its"
	db "<NEXT>", "own high voltage"
	db "<NEXT>", "power"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DratiniDexEntry::
	db TX_START, "Long considered a"
	db "<NEXT>", "mythical #MON"
	db "<NEXT>", "until recently"

	db "<PAGE>", "when a small"
	db "<NEXT>", "colony was found"
	db "<NEXT>", "living underwater"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DragonairDexEntry::
	db TX_START, "A mystical #MON"
	db "<NEXT>", "that exudes a"
	db "<NEXT>", "gentle aura."

	db "<PAGE>", "Has the ability"
	db "<NEXT>", "to change climate"
	db "<NEXT>", "conditions"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KabutoDexEntry::
	db TX_START, "A #MON that"
	db "<NEXT>", "was resurrected"
	db "<NEXT>", "from a fossil"

	db "<PAGE>", "found in what was"
	db "<NEXT>", "once the ocean"
	db "<NEXT>", "floor eons ago"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KabutopsDexEntry::
	db TX_START, "Its sleek shape is"
	db "<NEXT>", "perfect for swim-"
	db "<NEXT>", "ming. It slashes"

	db "<PAGE>", "prey with its"
	db "<NEXT>", "claws and drains"
	db "<NEXT>", "the body fluids"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_HorseaDexEntry::
	db TX_START, "Known to shoot"
	db "<NEXT>", "down flying bugs"
	db "<NEXT>", "with precision"

	db "<PAGE>", "blasts of ink"
	db "<NEXT>", "from the surface"
	db "<NEXT>", "of the water"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SeadraDexEntry::
	db TX_START, "Capable of swim-"
	db "<NEXT>", "ming backwards by"
	db "<NEXT>", "rapidly flapping"

	db "<PAGE>", "its wing-like"
	db "<NEXT>", "pectoral fins and"
	db "<NEXT>", "stout tail"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SandshrewDexEntry::
	db TX_START, "Burrows deep"
	db "<NEXT>", "underground in"
	db "<NEXT>", "arid locations"

	db "<PAGE>", "far from water."
	db "<NEXT>", "It only emerges"
	db "<NEXT>", "to hunt for food"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SandslashDexEntry::
	db TX_START, "Curls up into a"
	db "<NEXT>", "spiny ball when"
	db "<NEXT>", "threatened. It"

	db "<PAGE>", "can roll while"
	db "<NEXT>", "curled up to"
	db "<NEXT>", "attack or escape"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_OmanyteDexEntry::
	db TX_START, "Although long"
	db "<NEXT>", "extinct, in rare"
	db "<NEXT>", "cases, it can be"

	db "<PAGE>", "genetically"
	db "<NEXT>", "resurrected from"
	db "<NEXT>", "fossils"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_OmastarDexEntry::
	db TX_START, "A prehistoric"
	db "<NEXT>", "#MON that died"
	db "<NEXT>", "out when its"

	db "<PAGE>", "heavy shell made"
	db "<NEXT>", "it impossible to"
	db "<NEXT>", "catch prey"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_JigglypuffDexEntry::
	db TX_START, "When its huge eyes"
	db "<NEXT>", "light up, it sings"
	db "<NEXT>", "a mysteriously"

	db "<PAGE>", "soothing melody"
	db "<NEXT>", "that lulls its"
	db "<NEXT>", "enemies to sleep"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_WigglytuffDexEntry::
	db TX_START, "The body is soft"
	db "<NEXT>", "and rubbery. When"
	db "<NEXT>", "angered, it will"

	db "<PAGE>", "suck in air and"
	db "<NEXT>", "inflate itself to"
	db "<NEXT>", "an enormous size"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_EeveeDexEntry::
	db TX_START, "Its genetic code"
	db "<NEXT>", "is irregular."
	db "<NEXT>", "It may mutate if"

	db "<PAGE>", "it is exposed to"
	db "<NEXT>", "radiation from"
	db "<NEXT>", "element STONEs"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_FlareonDexEntry::
	db TX_START, "When storing"
	db "<NEXT>", "thermal energy in"
	db "<NEXT>", "its body, its"

	db "<PAGE>", "temperature could"
	db "<NEXT>", "soar to over 1600"
	db "<NEXT>", "degrees"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_JolteonDexEntry::
	db TX_START, "It accumulates"
	db "<NEXT>", "negative ions in"
	db "<NEXT>", "the atmosphere to"

	db "<PAGE>", "blast out 10000-"
	db "<NEXT>", "volt lightning"
	db "<NEXT>", "bolts"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VaporeonDexEntry::
	db TX_START, "Lives close to"
	db "<NEXT>", "water. Its long"
	db "<NEXT>", "tail is ridged"

	db "<PAGE>", "with a fin which"
	db "<NEXT>", "is often mistaken"
	db "<NEXT>", "for a mermaid's"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MachopDexEntry::
	db TX_START, "Loves to build"
	db "<NEXT>", "its muscles."
	db "<NEXT>", "It trains in all"

	db "<PAGE>", "styles of martial"
	db "<NEXT>", "arts to become"
	db "<NEXT>", "even stronger"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ZubatDexEntry::
	db TX_START, "Forms colonies in"
	db "<NEXT>", "perpetually dark"
	db "<NEXT>", "places. Uses"

	db "<PAGE>", "ultrasonic waves"
	db "<NEXT>", "to identify and"
	db "<NEXT>", "approach targets"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_EkansDexEntry::
	db TX_START, "Moves silently"
	db "<NEXT>", "and stealthily."
	db "<NEXT>", "Eats the eggs of"

	db "<PAGE>", "birds, such as"
	db "<NEXT>", "PIDGEY and"
	db "<NEXT>", "SPEAROW, whole"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ParasDexEntry::
	db TX_START, "Burrows to suck"
	db "<NEXT>", "tree roots. The"
	db "<NEXT>", "mushrooms on its"

	db "<PAGE>", "back grow by draw-"
	db "<NEXT>", "ing nutrients from"
	db "<NEXT>", "the bug host"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PoliwhirlDexEntry::
	db TX_START, "Capable of living"
	db "<NEXT>", "in or out of"
	db "<NEXT>", "water. When out"

	db "<PAGE>", "of water, it"
	db "<NEXT>", "sweats to keep"
	db "<NEXT>", "its body slimy"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PoliwrathDexEntry::
	db TX_START, "An adept swimmer"
	db "<NEXT>", "at both the front"
	db "<NEXT>", "crawl and breast"

	db "<PAGE>", "stroke. Easily"
	db "<NEXT>", "overtakes the best"
	db "<NEXT>", "human swimmers"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_WeedleDexEntry::
	db TX_START, "Often found in"
	db "<NEXT>", "forests, eating"
	db "<NEXT>", "leaves."

	db "<PAGE>", "It has a sharp"
	db "<NEXT>", "venomous stinger"
	db "<NEXT>", "on its head"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KakunaDexEntry::
	db TX_START, "Almost incapable"
	db "<NEXT>", "of moving, this"
	db "<NEXT>", "#MON can only"

	db "<PAGE>", "harden its shell"
	db "<NEXT>", "to protect itself"
	db "<NEXT>", "from predators"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_BeedrillDexEntry::
	db TX_START, "Flies at high"
	db "<NEXT>", "speed and attacks"
	db "<NEXT>", "using its large"

	db "<PAGE>", "venomous stingers"
	db "<NEXT>", "on its forelegs"
	db "<NEXT>", "and tail"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DodrioDexEntry::
	db TX_START, "Uses its three"
	db "<NEXT>", "brains to execute"
	db "<NEXT>", "complex plans."

	db "<PAGE>", "While two heads"
	db "<NEXT>", "sleep, one head"
	db "<NEXT>", "stays awake"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PrimeapeDexEntry::
	db TX_START, "Always furious"
	db "<NEXT>", "and tenacious to"
	db "<NEXT>", "boot. It will not"

	db "<PAGE>", "abandon chasing"
	db "<NEXT>", "its quarry until"
	db "<NEXT>", "it is caught"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DugtrioDexEntry::
	db TX_START, "A team of DIGLETT"
	db "<NEXT>", "triplets."
	db "<NEXT>", "It triggers huge"

	db "<PAGE>", "earthquakes by"
	db "<NEXT>", "burrowing 60 miles"
	db "<NEXT>", "underground"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VenomothDexEntry::
	db TX_START, "The dust-like"
	db "<NEXT>", "scales covering"
	db "<NEXT>", "its wings are"

	db "<PAGE>", "color coded to"
	db "<NEXT>", "indicate the kinds"
	db "<NEXT>", "of poison it has"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_DewgongDexEntry::
	db TX_START, "Stores thermal"
	db "<NEXT>", "energy in its"
	db "<NEXT>", "body. Swims at a"

	db "<PAGE>", "steady 8 knots"
	db "<NEXT>", "even in intensely"
	db "<NEXT>", "cold waters"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_CaterpieDexEntry::
	db TX_START, "Its short feet"
	db "<NEXT>", "are tipped with"
	db "<NEXT>", "suction pads that"

	db "<PAGE>", "enable it to"
	db "<NEXT>", "tirelessly climb"
	db "<NEXT>", "slopes and walls"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MetapodDexEntry::
	db TX_START, "This #MON is"
	db "<NEXT>", "vulnerable to"
	db "<NEXT>", "attack while its"

	db "<PAGE>", "shell is soft,"
	db "<NEXT>", "exposing its weak"
	db "<NEXT>", "and tender body"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ButterfreeDexEntry::
	db TX_START, "In battle, it"
	db "<NEXT>", "flaps its wings"
	db "<NEXT>", "at high speed to"

	db "<PAGE>", "release highly"
	db "<NEXT>", "toxic dust into"
	db "<NEXT>", "the air"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MachampDexEntry::
	db TX_START, "Using its heavy"
	db "<NEXT>", "muscles, it throws"
	db "<NEXT>", "powerful punches"

	db "<PAGE>", "that can send the"
	db "<NEXT>", "victim clear over"
	db "<NEXT>", "the horizon"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GolduckDexEntry::
	db TX_START, "Often seen swim-"
	db "<NEXT>", "ming elegantly by"
	db "<NEXT>", "lake shores. It"

	db "<PAGE>", "is often mistaken"
	db "<NEXT>", "for the Japanese"
	db "<NEXT>", "monster, Kappa"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_HypnoDexEntry::
	db TX_START, "When it locks eyes"
	db "<NEXT>", "with an enemy, it"
	db "<NEXT>", "will use a mix of"

	db "<PAGE>", "PSI moves such as"
	db "<NEXT>", "HYPNOSIS and"
	db "<NEXT>", "CONFUSION"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GolbatDexEntry::
	db TX_START, "Once it strikes,"
	db "<NEXT>", "it will not stop"
	db "<NEXT>", "draining energy"

	db "<PAGE>", "from the victim"
	db "<NEXT>", "even if it gets"
	db "<NEXT>", "too heavy to fly"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MewtwoDexEntry::
	db TX_START, "It was created by"
	db "<NEXT>", "a scientist after"
	db "<NEXT>", "years of horrific"

	db "<PAGE>", "gene splicing and"
	db "<NEXT>", "DNA engineering"
	db "<NEXT>", "experiments"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SnorlaxDexEntry::
	db TX_START, "Very lazy. Just"
	db "<NEXT>", "eats and sleeps."
	db "<NEXT>", "As its rotund"

	db "<PAGE>", "bulk builds, it"
	db "<NEXT>", "becomes steadily"
	db "<NEXT>", "more slothful"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MagikarpDexEntry::
	db TX_START, "In the distant"
	db "<NEXT>", "past, it was"
	db "<NEXT>", "somewhat stronger"

	db "<PAGE>", "than the horribly"
	db "<NEXT>", "weak descendants"
	db "<NEXT>", "that exist today"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MukDexEntry::
	db TX_START, "Thickly covered"
	db "<NEXT>", "with a filthy,"
	db "<NEXT>", "vile sludge. It"

	db "<PAGE>", "is so toxic, even"
	db "<NEXT>", "its footprints"
	db "<NEXT>", "contain poison"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_KinglerDexEntry::
	db TX_START, "The large pincer"
	db "<NEXT>", "has 10000 hp of"
	db "<NEXT>", "crushing power."

	db "<PAGE>", "However, its huge"
	db "<NEXT>", "size makes it"
	db "<NEXT>", "unwieldy to use"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_CloysterDexEntry::
	db TX_START, "When attacked, it"
	db "<NEXT>", "launches its"
	db "<NEXT>", "horns in quick"

	db "<PAGE>", "volleys. Its"
	db "<NEXT>", "innards have"
	db "<NEXT>", "never been seen"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ElectrodeDexEntry::
	db TX_START, "It stores electric"
	db "<NEXT>", "energy under very"
	db "<NEXT>", "high pressure."

	db "<PAGE>", "It often explodes"
	db "<NEXT>", "with little or no"
	db "<NEXT>", "provocation"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_ClefableDexEntry::
	db TX_START, "A timid fairy"
	db "<NEXT>", "#MON that is"
	db "<NEXT>", "rarely seen. It"

	db "<PAGE>", "will run and hide"
	db "<NEXT>", "the moment it"
	db "<NEXT>", "senses people"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_WeezingDexEntry::
	db TX_START, "Where two kinds"
	db "<NEXT>", "of poison gases"
	db "<NEXT>", "meet, 2 KOFFINGs"

	db "<PAGE>", "can fuse into a"
	db "<NEXT>", "WEEZING over many"
	db "<NEXT>", "years"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PersianDexEntry::
	db TX_START, "Although its fur"
	db "<NEXT>", "has many admirers,"
	db "<NEXT>", "it is tough to"

	db "<PAGE>", "raise as a pet"
	db "<NEXT>", "because of its"
	db "<NEXT>", "fickle meanness"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MarowakDexEntry::
	db TX_START, "The bone it holds"
	db "<NEXT>", "is its key weapon."
	db "<NEXT>", "It throws the"

	db "<PAGE>", "bone skillfully"
	db "<NEXT>", "like a boomerang"
	db "<NEXT>", "to KO targets"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_HaunterDexEntry::
	db TX_START, "Because of its"
	db "<NEXT>", "ability to slip"
	db "<NEXT>", "through block"

	db "<PAGE>", "walls, it is said"
	db "<NEXT>", "to be from an-"
	db "<NEXT>", "other dimension"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_AbraDexEntry::
	db TX_START, "Using its ability"
	db "<NEXT>", "to read minds, it"
	db "<NEXT>", "will identify"

	db "<PAGE>", "impending danger"
	db "<NEXT>", "and TELEPORT to"
	db "<NEXT>", "safety"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_AlakazamDexEntry::
	db TX_START, "Its brain can out-"
	db "<NEXT>", "perform a super-"
	db "<NEXT>", "computer."

	db "<PAGE>", "Its intelligence"
	db "<NEXT>", "quotient is said"
	db "<NEXT>", "to be 5,000"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PidgeottoDexEntry::
	db TX_START, "Very protective"
	db "<NEXT>", "of its sprawling"
	db "<NEXT>", "territorial area,"

	db "<PAGE>", "this #MON will"
	db "<NEXT>", "fiercely peck at"
	db "<NEXT>", "any intruder"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PidgeotDexEntry::
	db TX_START, "When hunting, it"
	db "<NEXT>", "skims the surface"
	db "<NEXT>", "of water at high"

	db "<PAGE>", "speed to pick off"
	db "<NEXT>", "unwary prey such"
	db "<NEXT>", "as MAGIKARP"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_StarmieDexEntry::
	db TX_START, "Its central core"
	db "<NEXT>", "glows with the"
	db "<NEXT>", "seven colors of"

	db "<PAGE>", "the rainbow. Some"
	db "<NEXT>", "people value the"
	db "<NEXT>", "core as a gem"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_BulbasaurDexEntry::
	db TX_START, "A strange seed was"
	db "<NEXT>", "planted on its"
	db "<NEXT>", "back at birth."

	db "<PAGE>", "The plant sprouts"
	db "<NEXT>", "and grows with"
	db "<NEXT>", "this #MON"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VenusaurDexEntry::
	db TX_START, "The plant blooms"
	db "<NEXT>", "when it is"
	db "<NEXT>", "absorbing solar"

	db "<PAGE>", "energy. It stays"
	db "<NEXT>", "on the move to"
	db "<NEXT>", "seek sunlight"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_TentacruelDexEntry::
	db TX_START, "The tentacles are"
	db "<NEXT>", "normally kept"
	db "<NEXT>", "short. On hunts,"

	db "<PAGE>", "they are extended"
	db "<NEXT>", "to ensnare and"
	db "<NEXT>", "immobilize prey"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GoldeenDexEntry::
	db TX_START, "Its tail fin"
	db "<NEXT>", "billows like an"
	db "<NEXT>", "elegant ballroom"

	db "<PAGE>", "dress, giving it"
	db "<NEXT>", "the nickname of"
	db "<NEXT>", "the Water Queen"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SeakingDexEntry::
	db TX_START, "In the autumn"
	db "<NEXT>", "spawning season,"
	db "<NEXT>", "they can be seen"

	db "<PAGE>", "swimming power-"
	db "<NEXT>", "fully up rivers"
	db "<NEXT>", "and creeks"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PonytaDexEntry::
	db TX_START, "Its hooves are 10"
	db "<NEXT>", "times harder than"
	db "<NEXT>", "diamonds. It can"

	db "<PAGE>", "trample anything"
	db "<NEXT>", "completely flat"
	db "<NEXT>", "in little time"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_RapidashDexEntry::
	db TX_START, "Very competitive,"
	db "<NEXT>", "this #MON will"
	db "<NEXT>", "chase anything"

	db "<PAGE>", "that moves fast"
	db "<NEXT>", "in the hopes of"
	db "<NEXT>", "racing it"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_RattataDexEntry::
	db TX_START, "Bites anything"
	db "<NEXT>", "when it attacks."
	db "<NEXT>", "Small and very"

	db "<PAGE>", "quick, it is a"
	db "<NEXT>", "common sight in"
	db "<NEXT>", "many places"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_RaticateDexEntry::
	db TX_START, "It uses its whis-"
	db "<NEXT>", "kers to maintain"
	db "<NEXT>", "its balance."

	db "<PAGE>", "It apparently"
	db "<NEXT>", "slows down if"
	db "<NEXT>", "they are cut off"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NidorinoDexEntry::
	db TX_START, "An aggressive"
	db "<NEXT>", "#MON that is"
	db "<NEXT>", "quick to attack."

	db "<PAGE>", "The horn on its"
	db "<NEXT>", "head secretes a"
	db "<NEXT>", "powerful venom"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_NidorinaDexEntry::
	db TX_START, "The female's horn"
	db "<NEXT>", "develops slowly."
	db "<NEXT>", "Prefers physical"

	db "<PAGE>", "attacks such as"
	db "<NEXT>", "clawing and"
	db "<NEXT>", "biting"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GeodudeDexEntry::
	db TX_START, "Found in fields"
	db "<NEXT>", "and mountains."
	db "<NEXT>", "Mistaking them"

	db "<PAGE>", "for boulders,"
	db "<NEXT>", "people often step"
	db "<NEXT>", "or trip on them"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_PorygonDexEntry::
	db TX_START, "A #MON that"
	db "<NEXT>", "consists entirely"
	db "<NEXT>", "of programming"

	db "<PAGE>", "code. Capable of"
	db "<NEXT>", "moving freely in"
	db "<NEXT>", "cyberspace"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_AerodactylDexEntry::
	db TX_START, "A ferocious, pre-"
	db "<NEXT>", "historic #MON"
	db "<NEXT>", "that goes for the"

	db "<PAGE>", "enemy's throat"
	db "<NEXT>", "with its serrated"
	db "<NEXT>", "saw-like fangs"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_MagnemiteDexEntry::
	db TX_START, "Uses anti-gravity"
	db "<NEXT>", "to stay suspended."
	db "<NEXT>", "Appears without"

	db "<PAGE>", "warning and uses"
	db "<NEXT>", "THUNDER WAVE and"
	db "<NEXT>", "similar moves"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_CharmanderDexEntry::
	db TX_START, "Obviously prefers"
	db "<NEXT>", "hot places. When"
	db "<NEXT>", "it rains, steam"

	db "<PAGE>", "is said to spout"
	db "<NEXT>", "from the tip of"
	db "<NEXT>", "its tail"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_SquirtleDexEntry::
	db TX_START, "After birth, its"
	db "<NEXT>", "back swells and"
	db "<NEXT>", "hardens into a"

	db "<PAGE>", "shell. Powerfully"
	db "<NEXT>", "sprays foam from"
	db "<NEXT>", "its mouth"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_CharmeleonDexEntry::
	db TX_START, "When it swings"
	db "<NEXT>", "its burning tail,"
	db "<NEXT>", "it elevates the"

	db "<PAGE>", "temperature to"
	db "<NEXT>", "unbearably high"
	db "<NEXT>", "levels"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_WartortleDexEntry::
	db TX_START, "Often hides in"
	db "<NEXT>", "water to stalk"
	db "<NEXT>", "unwary prey. For"

	db "<PAGE>", "swimming fast, it"
	db "<NEXT>", "moves its ears to"
	db "<NEXT>", "maintain balance"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_CharizardDexEntry::
	db TX_START, "Spits fire that"
	db "<NEXT>", "is hot enough to"
	db "<NEXT>", "melt boulders."

	db "<PAGE>", "Known to cause"
	db "<NEXT>", "forest fires"
	db "<NEXT>", "unintentionally"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_OddishDexEntry::
	db TX_START, "During the day,"
	db "<NEXT>", "it keeps its face"
	db "<NEXT>", "buried in the"

	db "<PAGE>", "ground. At night,"
	db "<NEXT>", "it wanders around"
	db "<NEXT>", "sowing its seeds"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_GloomDexEntry::
	db TX_START, "The fluid that"
	db "<NEXT>", "oozes from its"
	db "<NEXT>", "mouth isn't drool."

	db "<PAGE>", "It is a nectar"
	db "<NEXT>", "that is used to"
	db "<NEXT>", "attract prey"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VileplumeDexEntry::
	db TX_START, "The larger its"
	db "<NEXT>", "petals, the more"
	db "<NEXT>", "toxic pollen it"

	db "<PAGE>", "contains. Its big"
	db "<NEXT>", "head is heavy and"
	db "<NEXT>", "hard to hold up"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_BellsproutDexEntry::
	db TX_START, "A carnivorous"
	db "<NEXT>", "#MON that traps"
	db "<NEXT>", "and eats bugs."

	db "<PAGE>", "It uses its root"
	db "<NEXT>", "feet to soak up"
	db "<NEXT>", "needed moisture"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_WeepinbellDexEntry::
	db TX_START, "It spits out"
	db "<NEXT>", "POISONPOWDER to"
	db "<NEXT>", "immobilize the"

	db "<PAGE>", "enemy and then"
	db "<NEXT>", "finishes it with"
	db "<NEXT>", "a spray of ACID"
	db "<DEXEND>@"

;@ path: data/pokemon/dex_text
_VictreebelDexEntry::
	db TX_START, "Said to live in"
	db "<NEXT>", "huge colonies"
	db "<NEXT>", "deep in jungles,"

	db "<PAGE>", "although no one"
	db "<NEXT>", "has ever returned"
	db "<NEXT>", "from there"
	db "<DEXEND>@"


SECTION "Move Names", ROMX

;@ path: data/moves/names
MoveNames::
	; in-battle "used <move name>!" text can only fit 12 (MOVE_NAME_LENGTH - 2) characters
	db "POUND", "@"
	db "KARATE CHOP", "@"
	db "DOUBLESLAP", "@"
	db "COMET PUNCH", "@"
	db "MEGA PUNCH", "@"
	db "PAY DAY", "@"
	db "FIRE PUNCH", "@"
	db "ICE PUNCH", "@"
	db "THUNDERPUNCH", "@"
	db "SCRATCH", "@"
	db "VICEGRIP", "@"
	db "GUILLOTINE", "@"
	db "RAZOR WIND", "@"
	db "SWORDS DANCE", "@"
	db "CUT", "@"
	db "GUST", "@"
	db "WING ATTACK", "@"
	db "WHIRLWIND", "@"
	db "FLY", "@"
	db "BIND", "@"
	db "SLAM", "@"
	db "VINE WHIP", "@"
	db "STOMP", "@"
	db "DOUBLE KICK", "@"
	db "MEGA KICK", "@"
	db "JUMP KICK", "@"
	db "ROLLING KICK", "@"
	db "SAND-ATTACK", "@"
	db "HEADBUTT", "@"
	db "HORN ATTACK", "@"
	db "FURY ATTACK", "@"
	db "HORN DRILL", "@"
	db "TACKLE", "@"
	db "BODY SLAM", "@"
	db "WRAP", "@"
	db "TAKE DOWN", "@"
	db "THRASH", "@"
	db "DOUBLE-EDGE", "@"
	db "TAIL WHIP", "@"
	db "POISON STING", "@"
	db "TWINEEDLE", "@"
	db "PIN MISSILE", "@"
	db "LEER", "@"
	db "BITE", "@"
	db "GROWL", "@"
	db "ROAR", "@"
	db "SING", "@"
	db "SUPERSONIC", "@"
	db "SONICBOOM", "@"
	db "DISABLE", "@"
	db "ACID", "@"
	db "EMBER", "@"
	db "FLAMETHROWER", "@"
	db "MIST", "@"
	db "WATER GUN", "@"
	db "HYDRO PUMP", "@"
	db "SURF", "@"
	db "ICE BEAM", "@"
	db "BLIZZARD", "@"
	db "PSYBEAM", "@"
	db "BUBBLEBEAM", "@"
	db "AURORA BEAM", "@"
	db "HYPER BEAM", "@"
	db "PECK", "@"
	db "DRILL PECK", "@"
	db "SUBMISSION", "@"
	db "LOW KICK", "@"
	db "COUNTER", "@"
	db "SEISMIC TOSS", "@"
	db "STRENGTH", "@"
	db "ABSORB", "@"
	db "MEGA DRAIN", "@"
	db "LEECH SEED", "@"
	db "GROWTH", "@"
	db "RAZOR LEAF", "@"
	db "SOLARBEAM", "@"
	db "POISONPOWDER", "@"
	db "STUN SPORE", "@"
	db "SLEEP POWDER", "@"
	db "PETAL DANCE", "@"
	db "STRING SHOT", "@"
	db "DRAGON RAGE", "@"
	db "FIRE SPIN", "@"
	db "THUNDERSHOCK", "@"
	db "THUNDERBOLT", "@"
	db "THUNDER WAVE", "@"
	db "THUNDER", "@"
	db "ROCK THROW", "@"
	db "EARTHQUAKE", "@"
	db "FISSURE", "@"
	db "DIG", "@"
	db "TOXIC", "@"
	db "CONFUSION", "@"
	db "PSYCHIC", "@"
	db "HYPNOSIS", "@"
	db "MEDITATE", "@"
	db "AGILITY", "@"
	db "QUICK ATTACK", "@"
	db "RAGE", "@"
	db "TELEPORT", "@"
	db "NIGHT SHADE", "@"
	db "MIMIC", "@"
	db "SCREECH", "@"
	db "DOUBLE TEAM", "@"
	db "RECOVER", "@"
	db "HARDEN", "@"
	db "MINIMIZE", "@"
	db "SMOKESCREEN", "@"
	db "CONFUSE RAY", "@"
	db "WITHDRAW", "@"
	db "DEFENSE CURL", "@"
	db "BARRIER", "@"
	db "LIGHT SCREEN", "@"
	db "HAZE", "@"
	db "REFLECT", "@"
	db "FOCUS ENERGY", "@"
	db "BIDE", "@"
	db "METRONOME", "@"
	db "MIRROR MOVE", "@"
	db "SELFDESTRUCT", "@"
	db "EGG BOMB", "@"
	db "LICK", "@"
	db "SMOG", "@"
	db "SLUDGE", "@"
	db "BONE CLUB", "@"
	db "FIRE BLAST", "@"
	db "WATERFALL", "@"
	db "CLAMP", "@"
	db "SWIFT", "@"
	db "SKULL BASH", "@"
	db "SPIKE CANNON", "@"
	db "CONSTRICT", "@"
	db "AMNESIA", "@"
	db "KINESIS", "@"
	db "SOFTBOILED", "@"
	db "HI JUMP KICK", "@"
	db "GLARE", "@"
	db "DREAM EATER", "@"
	db "POISON GAS", "@"
	db "BARRAGE", "@"
	db "LEECH LIFE", "@"
	db "LOVELY KISS", "@"
	db "SKY ATTACK", "@"
	db "TRANSFORM", "@"
	db "BUBBLE", "@"
	db "DIZZY PUNCH", "@"
	db "SPORE", "@"
	db "FLASH", "@"
	db "PSYWAVE", "@"
	db "SPLASH", "@"
	db "ACID ARMOR", "@"
	db "CRABHAMMER", "@"
	db "EXPLOSION", "@"
	db "FURY SWIPES", "@"
	db "BONEMERANG", "@"
	db "REST", "@"
	db "ROCK SLIDE", "@"
	db "HYPER FANG", "@"
	db "SHARPEN", "@"
	db "CONVERSION", "@"
	db "TRI ATTACK", "@"
	db "SUPER FANG", "@"
	db "SLASH", "@"
	db "SUBSTITUTE", "@"
	db "STRUGGLE", "@"
