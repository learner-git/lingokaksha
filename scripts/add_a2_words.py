import json
import os

existing_words_file = "/Users/lalit/Data/flutter/lingokaksha/assets/data/vocab_a2.json"

new_words = [
    {
        "german": "die Einladung", "english": "invitation", "level": "A2", "category": "Social",
        "example": "Vielen Dank für die Einladung.",
        "examplePresent": "Ich schreibe eine Einladung.", "translationPresent": "I am writing an invitation.",
        "examplePast": "Er hat die Einladung angenommen.", "translationPast": "He accepted the invitation.",
        "exampleFuture": "Wir werden eine Einladung schicken.", "translationFuture": "We will send an invitation."
    },
    {
        "german": "feiern", "english": "to celebrate", "level": "A2", "category": "Social",
        "example": "Wir feiern heute meinen Geburtstag.",
        "examplePresent": "Sie feiern die ganze Nacht.", "translationPresent": "They are celebrating all night.",
        "examplePast": "Wir haben gestern ein schönes Fest gefeiert.", "translationPast": "We celebrated a nice party yesterday.",
        "exampleFuture": "Nächste Woche werden wir den Erfolg feiern.", "translationFuture": "Next week we will celebrate the success."
    },
    {
        "german": "schenken", "english": "to give a gift", "level": "A2", "category": "Social",
        "example": "Ich schenke dir ein Buch.",
        "examplePresent": "Er schenkt seiner Mutter Blumen.", "translationPresent": "He is giving his mother flowers.",
        "examplePast": "Sie hat mir eine Uhr geschenkt.", "translationPast": "She gave me a watch as a gift.",
        "exampleFuture": "Ich werde ihm etwas Schönes schenken.", "translationFuture": "I will give him something nice."
    },
    {
        "german": "das Geschenk", "english": "gift", "level": "A2", "category": "Social",
        "example": "Das ist ein tolles Geschenk.",
        "examplePresent": "Das Geschenk liegt auf dem Tisch.", "translationPresent": "The gift is lying on the table.",
        "examplePast": "Das Geschenk war sehr teuer.", "translationPast": "The gift was very expensive.",
        "exampleFuture": "Das wird ein großes Geschenk sein.", "translationFuture": "That will be a big gift."
    },
    {
        "german": "ausleihen", "english": "to borrow/lend", "level": "A2", "category": "Daily Life",
        "example": "Kannst du mir dein Fahrrad ausleihen?",
        "examplePresent": "Ich leihe mir ein Buch in der Bibliothek aus.", "translationPresent": "I am borrowing a book from the library.",
        "examplePast": "Er hat sich gestern Geld ausgeliehen.", "translationPast": "He borrowed money yesterday.",
        "exampleFuture": "Wir werden uns einen Film ausleihen.", "translationFuture": "We will borrow a movie."
    },
    {
        "german": "die Aufgabe", "english": "task/assignment", "level": "A2", "category": "Education",
        "example": "Das ist eine schwierige Aufgabe.",
        "examplePresent": "Ich erledige meine Aufgabe.", "translationPresent": "I am completing my task.",
        "examplePast": "Die Aufgabe war gestern fällig.", "translationPast": "The task was due yesterday.",
        "exampleFuture": "Das wird eine interessante Aufgabe sein.", "translationFuture": "That will be an interesting task."
    },
    {
        "german": "die Prüfung", "english": "exam", "level": "A2", "category": "Education",
        "example": "Ich habe morgen eine wichtige Prüfung.",
        "examplePresent": "Die Prüfung findet jetzt statt.", "translationPresent": "The exam is taking place now.",
        "examplePast": "Die Prüfung war sehr schwer.", "translationPast": "The exam was very difficult.",
        "exampleFuture": "Ich werde die Prüfung hoffentlich bestehen.", "translationFuture": "I will hopefully pass the exam."
    },
    {
        "german": "bestehen", "english": "to pass (exam)", "level": "A2", "category": "Education",
        "example": "Er hat die Prüfung bestanden.",
        "examplePresent": "Ich bestehe den Test sicher.", "translationPresent": "I am passing the test for sure.",
        "examplePast": "Sie hat alle Prüfungen bestanden.", "translationPast": "She passed all exams.",
        "exampleFuture": "Du wirst die Fahrprüfung bestehen.", "translationFuture": "You will pass the driving test."
    },
    {
        "german": "wiederholen", "english": "to repeat", "level": "A2", "category": "Education",
        "example": "Können Sie das bitte wiederholen?",
        "examplePresent": "Ich wiederhole die Vokabeln.", "translationPresent": "I am repeating the vocabulary.",
        "examplePast": "Wir haben den Film gestern wiederholt.", "translationPast": "We repeated (watched again) the movie yesterday.",
        "exampleFuture": "Er wird die Frage noch einmal wiederholen.", "translationFuture": "He will repeat the question once more."
    },
    {
        "german": "die Lösung", "english": "solution", "level": "A2", "category": "Education",
        "example": "Gibt es eine Lösung für das Problem?",
        "examplePresent": "Die Lösung steht im Buch.", "translationPresent": "The solution is in the book.",
        "examplePast": "Die Lösung war ganz einfach.", "translationPast": "The solution was quite simple.",
        "exampleFuture": "Wir werden bald die Lösung finden.", "translationFuture": "We will find the solution soon."
    },
    {
        "german": "korrigieren", "english": "to correct", "level": "A2", "category": "Education",
        "example": "Der Lehrer korrigiert die Hausaufgaben.",
        "examplePresent": "Ich korrigiere meine Fehler.", "translationPresent": "I am correcting my mistakes.",
        "examplePast": "Sie hat den Text gestern korrigiert.", "translationPast": "She corrected the text yesterday.",
        "exampleFuture": "Er wird die Arbeiten am Wochenende korrigieren.", "translationFuture": "He will correct the papers at the weekend."
    },
    {
        "german": "der Fehler", "english": "error/mistake", "level": "A2", "category": "Education",
        "example": "Ich habe einen Fehler gemacht.",
        "examplePresent": "Dieser Fehler passiert oft.", "translationPresent": "This mistake happens often.",
        "examplePast": "Der Fehler war peinlich.", "translationPast": "The mistake was embarrassing.",
        "exampleFuture": "Das wird kein großer Fehler sein.", "translationFuture": "That won't be a big mistake."
    },
    {
        "german": "vergessen", "english": "to forget", "level": "A2", "category": "Daily Life",
        "example": "Ich habe meinen Schlüssel vergessen.",
        "examplePresent": "Er vergisst immer seinen Namen.", "translationPresent": "He always forgets his name.",
        "examplePast": "Ich habe gestern den termin vergessen.", "translationPast": "I forgot the appointment yesterday.",
        "exampleFuture": "Ich werde dich nie vergessen.", "translationFuture": "I will never forget you."
    },
    {
        "german": "behalten", "english": "to keep", "level": "A2", "category": "Daily Life",
        "example": "Darf ich das Buch behalten?",
        "examplePresent": "Er behält sein altes Auto.", "translationPresent": "He is keeping his old car.",
        "examplePast": "Sie hat das Geheimnis für sich behalten.", "translationPast": "She kept the secret to herself.",
        "exampleFuture": "Ich werde die Informationen im Kopf behalten.", "translationFuture": "I will keep the information in mind."
    },
    {
        "german": "das Hobby", "english": "hobby", "level": "A2", "category": "Free Time",
        "example": "Mein Hobby ist Fotografieren.",
        "examplePresent": "Hobbys sind wichtig für die Entspannung.", "translationPresent": "Hobbies are important for relaxation.",
        "examplePast": "Früher war Fußball mein Hobby.", "translationPast": "Football used to be my hobby.",
        "exampleFuture": "Ich werde mir ein neues Hobby suchen.", "translationFuture": "I will look for a new hobby."
    },
    {
        "german": "wandern", "english": "to hike", "level": "A2", "category": "Free Time",
        "example": "Wir wandern gerne in den Bergen.",
        "examplePresent": "Heute wandere ich allein.", "translationPresent": "Today I am hiking alone.",
        "examplePast": "Wir sind letzte Woche zehn Kilometer gewandert.", "translationPast": "We hiked ten kilometers last week.",
        "exampleFuture": "Morgen werden wir im Wald wandern.", "translationFuture": "Tomorrow we will hike in the forest."
    },
    {
        "german": "tanzen", "english": "to dance", "level": "A2", "category": "Free Time",
        "example": "Tanzt du gerne?",
        "examplePresent": "Sie tanzt im Ballett.", "translationPresent": "She is dancing in ballet.",
        "examplePast": "Wir haben auf der Party viel getanzt.", "translationPast": "We danced a lot at the party.",
        "exampleFuture": "Wir werden bei der Hochzeit tanzen.", "translationFuture": "We will dance at the wedding."
    },
    {
        "german": "singen", "english": "to sing", "level": "A2", "category": "Free Time",
        "example": "Er singt in einem Chor.",
        "examplePresent": "Ich singe unter der Dusche.", "translationPresent": "I am singing in the shower.",
        "examplePast": "Sie hat gestern ein schönes Lied gesungen.", "translationPast": "She sang a beautiful song yesterday.",
        "exampleFuture": "Wir werden zusammen singen.", "translationFuture": "We will sing together."
    },
    {
        "german": "malen", "english": "to paint", "level": "A2", "category": "Free Time",
        "example": "Das Kind malt ein Bild.",
        "examplePresent": "Ich male die Wand blau.", "translationPresent": "I am painting the wall blue.",
        "examplePast": "Er hat ein Porträt gemalt.", "translationPast": "He painted a portrait.",
        "exampleFuture": "Ich werde morgen eine Landschaft malen.", "translationFuture": "I will paint a landscape tomorrow."
    },
    {
        "german": "zeichnen", "english": "to draw", "level": "A2", "category": "Free Time",
        "example": "Kannst du gut zeichnen?",
        "examplePresent": "Er zeichnet einen Comic.", "translationPresent": "He is drawing a comic.",
        "examplePast": "Sie hat einen Plan gezeichnet.", "translationPast": "She drew a plan.",
        "exampleFuture": "Wir werden morgen Skizzen zeichnen.", "translationFuture": "We will draw sketches tomorrow."
    },
    {
        "german": "fotografieren", "english": "to photograph", "level": "A2", "category": "Free Time",
        "example": "Ich fotografiere gerne Tiere.",
        "examplePresent": "Er fotografiert die Sehenswürdigkeiten.", "translationPresent": "He is photographing the sights.",
        "examplePast": "Ich habe gestern viele Fotos fotografiert.", "translationPast": "I took (photographed) many photos yesterday.",
        "exampleFuture": "Wir werden bei der Reise viel fotografieren.", "translationFuture": "We will photograph a lot during the trip."
    },
    {
        "german": "die Kamera", "english": "camera", "level": "A2", "category": "Free Time",
        "example": "Wo ist meine Kamera?",
        "examplePresent": "Die Kamera macht gute Bilder.", "translationPresent": "The camera takes good pictures.",
        "examplePast": "Die Kamera war teuer.", "translationPast": "The camera was expensive.",
        "exampleFuture": "Ich werde eine neue Kamera kaufen.", "translationFuture": "I will buy a new camera."
    },
    {
        "german": "der Sport", "english": "sport", "level": "A2", "category": "Health",
        "example": "Treibst du Sport?",
        "examplePresent": "Sport ist gesund.", "translationPresent": "Sport is healthy.",
        "examplePast": "Früher habe ich viel Sport gemacht.", "translationPast": "I used to do a lot of sports.",
        "exampleFuture": "Ich werde ab morgen mehr Sport treiben.", "translationFuture": "I will do more sports from tomorrow."
    },
    {
        "german": "trainieren", "english": "to train", "level": "A2", "category": "Health",
        "example": "Ich trainiere dreimal pro Woche.",
        "examplePresent": "Er trainiert für den Marathon.", "translationPresent": "He is training for the marathon.",
        "examplePast": "Wir haben gestern hart trainiert.", "translationPast": "We trained hard yesterday.",
        "exampleFuture": "Wir werden im Fitnessstudio trainieren.", "translationFuture": "We will train at the gym."
    },
    {
        "german": "gewinnen", "english": "to win", "level": "A2", "category": "Health",
        "example": "Wir wollen das Spiel gewinnen.",
        "examplePresent": "Er gewinnt fast immer.", "translationPresent": "He wins almost always.",
        "examplePast": "Unsere Mannschaft hat gestern gewonnen.", "translationPast": "Our team won yesterday.",
        "exampleFuture": "Ich hoffe, wir werden gewinnen.", "translationFuture": "I hope we will win."
    },
    {
        "german": "verlieren", "english": "to lose", "level": "A2", "category": "Health",
        "example": "Verlieren ist nicht einfach.",
        "examplePresent": "Ich verliere oft meine Brille.", "translationPresent": "I often lose my glasses.",
        "examplePast": "Er hat das Spiel gestern verloren.", "translationPast": "He lost the game yesterday.",
        "exampleFuture": "Du wirst den Mut nicht verlieren.", "translationFuture": "You will not lose courage."
    },
    {
        "german": "die Mannschaft", "english": "team", "level": "A2", "category": "Health",
        "example": "Die Mannschaft spielt gut.",
        "examplePresent": "Unsere Mannschaft trainiert heute.", "translationPresent": "Our team is training today.",
        "examplePast": "Die Mannschaft war enttäuscht.", "translationPast": "The team was disappointed.",
        "exampleFuture": "Die Mannschaft wird bald berühmt sein.", "translationFuture": "The team will soon be famous."
    },
    {
        "german": "der Verein", "english": "club/association", "level": "A2", "category": "Social",
        "example": "Ich bin Mitglied in einem Verein.",
        "examplePresent": "Der Verein hat viele Mitglieder.", "translationPresent": "The club has many members.",
        "examplePast": "Der Verein war früher kleiner.", "translationPast": "The club used to be smaller.",
        "exampleFuture": "Wir werden einen neuen Verein gründen.", "translationFuture": "We will found a new club."
    },
    {
        "german": "die Freizeit", "english": "free time", "level": "A2", "category": "Free Time",
        "example": "Was machst du in deiner Freizeit?",
        "examplePresent": "Die Freizeit ist kostbar.", "translationPresent": "Free time is precious.",
        "examplePast": "Gestern hatte ich keine Freizeit.", "translationPast": "Yesterday I had no free time.",
        "exampleFuture": "Ich werde am Wochenende viel Freizeit haben.", "translationFuture": "I will have a lot of free time at the weekend."
    },
    {
        "german": "ausruhen", "english": "to rest", "level": "A2", "category": "Health",
        "example": "Ich muss mich kurz ausruhen.",
        "examplePresent": "Er ruht sich auf dem Sofa aus.", "translationPresent": "He is resting on the sofa.",
        "examplePast": "Ich habe mich nach der Arbeit ausgeruht.", "translationPast": "I rested after work.",
        "exampleFuture": "Wir werden uns am Strand ausruhen.", "translationFuture": "We will rest on the beach."
    },
    {
        "german": "entspannen", "english": "to relax", "level": "A2", "category": "Health",
        "example": "Musik hilft mir beim Entspannen.",
        "examplePresent": "Ich entspanne mich im Garten.", "translationPresent": "I am relaxing in the garden.",
        "examplePast": "Wir haben uns am Wochenende entspannt.", "translationPast": "We relaxed at the weekend.",
        "exampleFuture": "Du wirst dich im Urlaub sicher entspannen.", "translationFuture": "You will surely relax on vacation."
    },
    {
        "german": "stressig", "english": "stressful", "level": "A2", "category": "Daily Life",
        "example": "Mein Job ist sehr stressig.",
        "examplePresent": "Der Tag heute ist stressig.", "translationPresent": "The day today is stressful.",
        "examplePast": "Die letzte Woche war stressig.", "translationPast": "Last week was stressful.",
        "exampleFuture": "Die Reise wird hoffentlich nicht stressig sein.", "translationFuture": "The trip will hopefully not be stressful."
    },
    {
        "german": "gemütlich", "english": "cozy", "level": "A2", "category": "House",
        "example": "Das Wohnzimmer ist sehr gemütlich.",
        "examplePresent": "Ich mache es mir gemütlich.", "translationPresent": "I am making myself cozy.",
        "examplePast": "Der Abend war gemütlich.", "translationPast": "The evening was cozy.",
        "exampleFuture": "Das neue Haus wird gemütlich sein.", "translationFuture": "The new house will be cozy."
    },
    {
        "german": "der Wald", "english": "forest", "level": "A2", "category": "Nature",
        "example": "Im Wald ist es ruhig.",
        "examplePresent": "Der Wald ist im Sommer grün.", "translationPresent": "The forest is green in summer.",
        "examplePast": "Der Wald war früher größer.", "translationPast": "The forest used to be bigger.",
        "exampleFuture": "Wir werden durch den Wald laufen.", "translationFuture": "We will walk through the forest."
    },
    {
        "german": "die Natur", "english": "nature", "level": "A2", "category": "Nature",
        "example": "Ich liebe die Natur.",
        "examplePresent": "Die Natur erwacht im Frühling.", "translationPresent": "Nature awakens in spring.",
        "examplePast": "Die Natur war dort unberührt.", "translationPast": "Nature was untouched there.",
        "exampleFuture": "Die Natur wird sich hoffentlich erholen.", "translationFuture": "Nature will hopefully recover."
    },
    {
        "german": "der Berg", "english": "mountain", "level": "A2", "category": "Nature",
        "example": "Der Berg ist mit Schnee bedeckt.",
        "examplePresent": "Die Berge sehen toll aus.", "translationPresent": "The mountains look great.",
        "examplePast": "Der Berg war schwer zu besteigen.", "translationPast": "The mountain was difficult to climb.",
        "exampleFuture": "Wir werden auf den Berg wandern.", "translationFuture": "We will hike onto the mountain."
    },
    {
        "german": "der See", "english": "lake", "level": "A2", "category": "Nature",
        "example": "Wir schwimmen im See.",
        "examplePresent": "Der See ist heute ruhig.", "translationPresent": "The lake is calm today.",
        "examplePast": "Der See war gefroren.", "translationPast": "The lake was frozen.",
        "exampleFuture": "Wir werden am See grillen.", "translationFuture": "We will grill by the lake."
    },
    {
        "german": "das Meer", "english": "sea", "level": "A2", "category": "Nature",
        "example": "Das Meer ist blau.",
        "examplePresent": "Ich sitze am Meer.", "translationPresent": "I am sitting by the sea.",
        "examplePast": "Das Meer war gestern stürmisch.", "translationPast": "The sea was stormy yesterday.",
        "exampleFuture": "Wir werden nächstes Jahr ans Meer fahren.", "translationFuture": "We will go to the sea next year."
    },
    {
        "german": "der Strand", "english": "beach", "level": "A2", "category": "Nature",
        "example": "Wir liegen am Strand.",
        "examplePresent": "Der Strand ist sauber.", "translationPresent": "The beach is clean.",
        "examplePast": "Der Strand war voller Menschen.", "translationPast": "The beach was full of people.",
        "exampleFuture": "Wir werden am Strand spazieren gehen.", "translationFuture": "We will walk on the beach."
    },
    {
        "german": "die Insel", "english": "island", "level": "A2", "category": "Nature",
        "example": "Sylt ist eine schöne Insel.",
        "examplePresent": "Die Insel liegt in der Nordsee.", "translationPresent": "The island lies in the North Sea.",
        "examplePast": "Die Insel war unbewohnt.", "translationPast": "The island was uninhabited.",
        "exampleFuture": "Wir werden die Insel besuchen.", "translationFuture": "We will visit the island."
    },
    {
        "german": "die Luft", "english": "air", "level": "A2", "category": "Nature",
        "example": "Die Luft hier ist frisch.",
        "examplePresent": "Ich brauche frische Luft.", "translationPresent": "I need fresh air.",
        "examplePast": "Die Luft war gestern stickig.", "translationPast": "The air was stuffy yesterday.",
        "exampleFuture": "Die Luft wird bald kühler sein.", "translationFuture": "The air will soon be cooler."
    },
    {
        "german": "die Sonne", "english": "sun", "level": "A2", "category": "Nature",
        "example": "Die Sonne scheint hell.",
        "examplePresent": "Die Sonne geht gerade auf.", "translationPresent": "The sun is just rising.",
        "examplePast": "Die Sonne war sehr heiß.", "translationPast": "The sun was very hot.",
        "exampleFuture": "Morgen wird die Sonne scheinen.", "translationFuture": "Tomorrow the sun will shine."
    },
    {
        "german": "der Regen", "english": "rain", "level": "A2", "category": "Nature",
        "example": "Der Regen ist gut für die Blumen.",
        "examplePresent": "Der Regen hört nicht auf.", "translationPresent": "The rain doesn't stop.",
        "examplePast": "Der Regen war sehr stark.", "translationPast": "The rain was very strong.",
        "exampleFuture": "Wir werden bald Regen bekommen.", "translationFuture": "We will have rain soon."
    },
    {
        "german": "der Schnee", "english": "snow", "level": "A2", "category": "Nature",
        "example": "Im Winter liegt viel Schnee.",
        "examplePresent": "Der Schnee schmilzt.", "translationPresent": "The snow is melting.",
        "examplePast": "Der Schnee war weich.", "translationPast": "The snow was soft.",
        "exampleFuture": "Morgen wird es viel Schnee geben.", "translationFuture": "There will be a lot of snow tomorrow."
    },
    {
        "german": "windig", "english": "windy", "level": "A2", "category": "Nature",
        "example": "Heute ist es sehr windig.",
        "examplePresent": "Draußen ist es windig.", "translationPresent": "It is windy outside.",
        "examplePast": "Gestern war es extrem windig.", "translationPast": "Yesterday it was extremely windy.",
        "exampleFuture": "Es wird am Abend windig werden.", "translationFuture": "It will get windy in the evening."
    },
    {
        "german": "bewölkt", "english": "cloudy", "level": "A2", "category": "Nature",
        "example": "Der Himmel ist bewölkt.",
        "examplePresent": "Es ist heute bewölkt.", "translationPresent": "It is cloudy today.",
        "examplePast": "Gestern war es den ganzen Tag bewölkt.", "translationPast": "Yesterday it was cloudy all day.",
        "exampleFuture": "Es wird morgen bewölkt sein.", "translationFuture": "It will be cloudy tomorrow."
    },
    {
        "german": "die Kleidung", "english": "clothes", "level": "A2", "category": "Daily Life",
        "example": "Ich brauche neue Kleidung.",
        "examplePresent": "Die Kleidung ist in der Waschmaschine.", "translationPresent": "The clothes are in the washing machine.",
        "examplePast": "Seine Kleidung war nass.", "translationPast": "His clothes were wet.",
        "exampleFuture": "Ich werde warme Kleidung mitnehmen.", "translationFuture": "I will take warm clothes with me."
    },
    {
        "german": "die Hose", "english": "pants", "level": "A2", "category": "Daily Life",
        "example": "Diese Hose passt mir gut.",
        "examplePresent": "Die Hose ist neu.", "translationPresent": "The pants are new.",
        "examplePast": "Die Hose war zu lang.", "translationPast": "The pants were too long.",
        "exampleFuture": "Ich werde eine schwarze Hose tragen.", "translationFuture": "I will wear black pants."
    },
    {
        "german": "das Hemd", "english": "shirt", "level": "A2", "category": "Daily Life",
        "example": "Er trägt ein weißes Hemd.",
        "examplePresent": "Das Hemd ist gebügelt.", "translationPresent": "The shirt is ironed.",
        "examplePast": "Das Hemd war schmutzig.", "translationPast": "The shirt was dirty.",
        "exampleFuture": "Ich werde mein bestes Hemd anziehen.", "translationFuture": "I will put on my best shirt."
    },
    {
        "german": "das Kleid", "english": "dress", "level": "A2", "category": "Daily Life",
        "example": "Sie trägt ein schönes Kleid.",
        "examplePresent": "Das Kleid steht ihr gut.", "translationPresent": "The dress suits her well.",
        "examplePast": "Das Kleid war ein Geschenk.", "translationPast": "The dress was a gift.",
        "exampleFuture": "Sie wird ein rotes Kleid kaufen.", "translationFuture": "She will buy a red dress."
    },
    {
        "german": "der Schuh", "english": "shoe", "level": "A2", "category": "Daily Life",
        "example": "Die Schuhe sind zu klein.",
        "examplePresent": "Ich trage braune Schuhe.", "translationPresent": "I am wearing brown shoes.",
        "examplePast": "Meine Schuhe waren gestern schmutzig.", "translationPast": "My shoes were dirty yesterday.",
        "exampleFuture": "Ich werde mir neue Schuhe kaufen.", "translationFuture": "I will buy new shoes."
    },
    {
        "german": "die Jacke", "english": "jacket", "level": "A2", "category": "Daily Life",
        "example": "Zieh deine Jacke an.",
        "examplePresent": "Die Jacke ist warm.", "translationPresent": "The jacket is warm.",
        "examplePast": "Die Jacke war teuer.", "translationPast": "The jacket was expensive.",
        "exampleFuture": "Ich werde eine leichte Jacke mitnehmen.", "translationFuture": "I will take a light jacket with me."
    },
    {
        "german": "der Mantel", "english": "coat", "level": "A2", "category": "Daily Life",
        "example": "Der Mantel hängt im Schrank.",
        "examplePresent": "Der Mantel passt mir gut.", "translationPresent": "The coat fits me well.",
        "examplePast": "Der Mantel war im Angebot.", "translationPast": "The coat was on sale.",
        "exampleFuture": "Ich werde den Mantel morgen tragen.", "translationFuture": "I will wear the coat tomorrow."
    },
    {
        "german": "die Tasche", "english": "bag", "level": "A2", "category": "Daily Life",
        "example": "In meiner Tasche ist viel Platz.",
        "examplePresent": "Die Tasche ist schwer.", "translationPresent": "The bag is heavy.",
        "examplePast": "Die Tasche war verloren gegangen.", "translationPast": "The bag was lost.",
        "exampleFuture": "Ich werde eine Tasche für die Reise brauchen.", "translationFuture": "I will need a bag for the trip."
    },
    {
        "german": "der Hut", "english": "hat", "level": "A2", "category": "Daily Life",
        "example": "Er trägt einen schwarzen Hut.",
        "examplePresent": "Der Hut schützt vor der Sonne.", "translationPresent": "The hat protects from the sun.",
        "examplePast": "Der Hut war ein Geschenk meines Opas.", "translationPast": "The hat was a gift from my grandpa.",
        "exampleFuture": "Ich werde einen Hut bei der Party tragen.", "translationFuture": "I will wear a hat at the party."
    },
    {
        "german": "die Brille", "english": "glasses", "level": "A2", "category": "Daily Life",
        "example": "Wo ist meine Brille?",
        "examplePresent": "Die Brille liegt auf dem Nachttisch.", "translationPresent": "The glasses are on the nightstand.",
        "examplePast": "Die Brille war gestern kaputt.", "translationPast": "The glasses were broken yesterday.",
        "exampleFuture": "Ich werde eine neue Brille brauchen.", "translationFuture": "I will need new glasses."
    },
    {
        "german": "der Schmuck", "english": "jewelry", "level": "A2", "category": "Daily Life",
        "example": "Sie trägt gerne teuren Schmuck.",
        "examplePresent": "Der Schmuck glänzt schön.", "translationPresent": "The jewelry shines beautifully.",
        "examplePast": "Der Schmuck war ein Erbstück.", "translationPast": "The jewelry was an heirloom.",
        "exampleFuture": "Ich werde ihr Schmuck schenken.", "translationFuture": "I will give her jewelry as a gift."
    },
    {
        "german": "die Gesundheit", "english": "health", "level": "A2", "category": "Health",
        "example": "Gesundheit ist das Wichtigste.",
        "examplePresent": "Die Gesundheit profitiert von Sport.", "translationPresent": "Health benefits from sports.",
        "examplePast": "Die Gesundheit war früher besser.", "translationPast": "Health was better before.",
        "exampleFuture": "Ich werde mehr auf meine Gesundheit achten.", "translationFuture": "I will pay more attention to my health."
    },
    {
        "german": "das Krankenhaus", "english": "hospital", "level": "A2", "category": "Health",
        "example": "Er liegt im Krankenhaus.",
        "examplePresent": "Das Krankenhaus ist sehr modern.", "translationPresent": "The hospital is very modern.",
        "examplePast": "Das Krankenhaus war weit weg.", "translationPast": "The hospital was far away.",
        "exampleFuture": "Wir werden morgen ins Krankenhaus fahren.", "translationFuture": "We will drive to the hospital tomorrow."
    },
    {
        "german": "die Apotheke", "english": "pharmacy", "level": "A2", "category": "Health",
        "example": "Wo ist die nächste Apotheke?",
        "examplePresent": "Die Apotheke hat gerade offen.", "translationPresent": "The pharmacy is open right now.",
        "examplePast": "Die Apotheke war gestern geschlossen.", "translationPast": "The pharmacy was closed yesterday.",
        "exampleFuture": "Ich werde in der Apotheke Medikamente kaufen.", "translationFuture": "I will buy medicine at the pharmacy."
    },
    {
        "german": "das Medikament", "english": "medicine", "level": "A2", "category": "Health",
        "example": "Ich muss das Medikament dreimal täglich nehmen.",
        "examplePresent": "Das Medikament hilft gegen die Schmerzen.", "translationPresent": "The medicine helps against the pain.",
        "examplePast": "Das Medikament war sehr teuer.", "translationPast": "The medicine was very expensive.",
        "exampleFuture": "Der Arzt wird mir ein Medikament verschreiben.", "translationFuture": "The doctor will prescribe a medicine for me."
    },
    {
        "german": "der Schmerz", "english": "pain", "level": "A2", "category": "Health",
        "example": "Ich habe Schmerzen im Rücken.",
        "examplePresent": "Der Schmerz lässt langsam nach.", "translationPresent": "The pain is slowly subsiding.",
        "examplePast": "Der Schmerz war unerträglich.", "translationPast": "The pain was unbearable.",
        "exampleFuture": "Die Tablette wird den Schmerz lindern.", "translationFuture": "The tablet will alleviate the pain."
    },
    {
        "german": "die Erkältung", "english": "cold/flu", "level": "A2", "category": "Health",
        "example": "Ich habe eine starke Erkältung.",
        "examplePresent": "Eine Erkältung dauert meistens eine Woche.", "translationPresent": "A cold usually lasts a week.",
        "examplePast": "Die Erkältung war letzte Woche schlimmer.", "translationPast": "The cold was worse last week.",
        "exampleFuture": "Viel Tee wird bei der Erkältung helfen.", "translationFuture": "A lot of tea will help with the cold."
    },
    {
        "german": "das Fieber", "english": "fever", "level": "A2", "category": "Health",
        "example": "Hast du Fieber?",
        "examplePresent": "Das Fieber ist heute gesunken.", "translationPresent": "The fever has dropped today.",
        "examplePast": "Er hatte gestern hohes Fieber.", "translationPast": "He had a high fever yesterday.",
        "exampleFuture": "Das Fieber wird hoffentlich bald weg sein.", "translationFuture": "The fever will hopefully be gone soon."
    },
    {
        "german": "husten", "english": "to cough", "level": "A2", "category": "Health",
        "example": "Warum hustest du so stark?",
        "examplePresent": "Ich huste schon den ganzen Tag.", "translationPresent": "I have been coughing all day.",
        "examplePast": "Er hat die ganze Nacht gehustet.", "translationPast": "He coughed all night.",
        "exampleFuture": "Ich werde morgen weniger husten.", "translationFuture": "I will cough less tomorrow."
    },
    {
        "german": "untersuchen", "english": "to examine", "level": "A2", "category": "Health",
        "example": "Der Arzt untersucht den Patienten.",
        "examplePresent": "Ich untersuche das problem genau.", "translationPresent": "I am examining the problem closely.",
        "examplePast": "Sie hat den Fall gestern untersucht.", "translationPast": "She examined the case yesterday.",
        "exampleFuture": "Wir werden die Ergebnisse morgen untersuchen.", "translationFuture": "We will examine the results tomorrow."
    },
    {
        "german": "verschreiben", "english": "to prescribe", "level": "A2", "category": "Health",
        "example": "Der Arzt verschreibt mir ein Rezept.",
        "examplePresent": "Er verschreibt oft dieses Medikament.", "translationPresent": "He often prescribes this medicine.",
        "examplePast": "Sie hat mir gestern Ruhe verschrieben.", "translationPast": "She prescribed rest for me yesterday.",
        "exampleFuture": "Der Arzt wird dir etwas gegen den Husten verschreiben.", "translationFuture": "The doctor will prescribe something for your cough."
    },
    {
        "german": "gesund werden", "english": "to get well", "level": "A2", "category": "Health",
        "example": "Ich hoffe, du wirst schnell gesund.",
        "examplePresent": "Ich werde langsam wieder gesund.", "translationPresent": "I am slowly getting well again.",
        "examplePast": "Er ist nach zwei Wochen wieder gesund geworden.", "translationPast": "He got well again after two weeks.",
        "exampleFuture": "Du wirst sicher bald gesund werden.", "translationFuture": "You will surely get well soon."
    },
    {
        "german": "die Besserung", "english": "improvement", "level": "A2", "category": "Health",
        "example": "Gute Besserung!",
        "examplePresent": "Ich sehe eine Besserung der Situation.", "translationPresent": "I see an improvement in the situation.",
        "examplePast": "Es gab gestern eine deutliche Besserung.", "translationPast": "There was a clear improvement yesterday.",
        "exampleFuture": "Das Medikament wird eine Besserung bringen.", "translationFuture": "The medicine will bring an improvement."
    },
    {
        "german": "das Handy", "english": "mobile phone", "level": "A2", "category": "Media",
        "example": "Mein Handy ist leer.",
        "examplePresent": "Das Handy klingelt gerade.", "translationPresent": "The mobile phone is ringing right now.",
        "examplePast": "Das Handy war gestern unauffindbar.", "translationPast": "The mobile phone was nowhere to be found yesterday.",
        "exampleFuture": "Ich werde mir ein neues Handy kaufen.", "translationFuture": "I will buy a new mobile phone."
    },
    {
        "german": "der Computer", "english": "computer", "level": "A2", "category": "Media",
        "example": "Ich arbeite am Computer.",
        "examplePresent": "Der Computer ist sehr schnell.", "translationPresent": "The computer is very fast.",
        "examplePast": "Der Computer war gestern kaputt.", "translationPast": "The computer was broken yesterday.",
        "exampleFuture": "Wir werden neue Computer installieren.", "translationFuture": "We will install new computers."
    },
    {
        "german": "das Internet", "english": "internet", "level": "A2", "category": "Media",
        "example": "Ich surfe im Internet.",
        "examplePresent": "Das Internet ist heute langsam.", "translationPresent": "The internet is slow today.",
        "examplePast": "Früher war das Internet teuer.", "translationPast": "The internet used to be expensive.",
        "exampleFuture": "Das Internet wird in Zukunft noch schneller sein.", "translationFuture": "The internet will be even faster in the future."
    },
    {
        "german": "die Webseite", "english": "website", "level": "A2", "category": "Media",
        "example": "Die Webseite ist sehr informativ.",
        "examplePresent": "Ich besuche die Webseite täglich.", "translationPresent": "I visit the website daily.",
        "examplePast": "Die Webseite war gestern nicht erreichbar.", "translationPast": "The website was not reachable yesterday.",
        "exampleFuture": "Wir werden die Webseite neu gestalten.", "translationFuture": "We will redesign the website."
    },
    {
        "german": "die E-Mail", "english": "email", "level": "A2", "category": "Media",
        "example": "Ich habe eine E-Mail geschrieben.",
        "examplePresent": "Ich bekomme viele E-Mails.", "translationPresent": "I receive many emails.",
        "examplePast": "Die E-Mail war im Spam-Ordner.", "translationPast": "The email was in the spam folder.",
        "exampleFuture": "Ich werde dir eine E-Mail schicken.", "translationFuture": "I will send you an email."
    },
    {
        "german": "das Passwort", "english": "password", "level": "A2", "category": "Media",
        "example": "Ich habe mein Passwort vergessen.",
        "examplePresent": "Das Passwort ist sicher.", "translationPresent": "The password is safe.",
        "examplePast": "Das Passwort war zu kurz.", "translationPast": "The password was too short.",
        "exampleFuture": "Ich werde mein Passwort morgen ändern.", "translationFuture": "I will change my password tomorrow."
    },
    {
        "german": "herunterladen", "english": "to download", "level": "A2", "category": "Media",
        "example": "Ich lade eine App herunter.",
        "examplePresent": "Er lädt gerade einen Film herunter.", "translationPresent": "He is downloading a movie right now.",
        "examplePast": "Ich habe die Datei gestern heruntergeladen.", "translationPast": "I downloaded the file yesterday.",
        "exampleFuture": "Wir werden das Programm später herunterladen.", "translationFuture": "We will download the program later."
    },
    {
        "german": "speichern", "english": "to save", "level": "A2", "category": "Media",
        "example": "Vergiss nicht zu speichern.",
        "examplePresent": "Ich speichere meine Dokumente in der Cloud.", "translationPresent": "I save my documents in the cloud.",
        "examplePast": "Er hat die Änderungen nicht gespeichert.", "translationPast": "He did not save the changes.",
        "exampleFuture": "Ich werde das Foto auf meinem Computer speichern.", "translationFuture": "I will save the photo on my computer."
    },
    {
        "german": "löschen", "english": "to delete", "level": "A2", "category": "Media",
        "example": "Kannst du die Datei löschen?",
        "examplePresent": "Ich lösche gerade alte E-Mails.", "translationPresent": "I am currently deleting old emails.",
        "examplePast": "Er hat die Nachricht versehentlich gelöscht.", "translationPast": "He deleted the message by mistake.",
        "exampleFuture": "Ich werde den Verlauf morgen löschen.", "translationFuture": "I will delete the history tomorrow."
    },
    {
        "german": "die Nachricht", "english": "message", "level": "A2", "category": "Media",
        "example": "Ich habe eine Nachricht erhalten.",
        "examplePresent": "Die Nachricht ist wichtig.", "translationPresent": "The message is important.",
        "examplePast": "Die Nachricht war gestern im Radio.", "translationPast": "The message was on the radio yesterday.",
        "exampleFuture": "Ich werde dir eine Nachricht schicken.", "translationFuture": "I will send you a message."
    },
    {
        "german": "anmachen", "english": "to turn on", "level": "A2", "category": "Daily Life",
        "example": "Kannst du das Licht anmachen?",
        "examplePresent": "Ich mache das Radio an.", "translationPresent": "I am turning on the radio.",
        "examplePast": "Er hat den Fernseher gestern Abend angemacht.", "translationPast": "He turned on the TV yesterday evening.",
        "exampleFuture": "Ich werde die Heizung gleich anmachen.", "translationFuture": "I will turn on the heating in a moment."
    },
    {
        "german": "ausmachen", "english": "to turn off", "level": "A2", "category": "Daily Life",
        "example": "Vergiss nicht, das Licht auszumachen.",
        "examplePresent": "Ich mache den Computer jetzt aus.", "translationPresent": "I am turning off the computer now.",
        "examplePast": "Hast du den Herd ausgemacht?", "translationPast": "Did you turn off the stove?",
        "exampleFuture": "Wir werden die Musik später ausmachen.", "translationFuture": "We will turn off the music later."
    },
    {
        "german": "funktionieren", "english": "to function", "level": "A2", "category": "Media",
        "example": "Die App funktioniert einwandfrei.",
        "examplePresent": "Das Internet funktioniert heute gut.", "translationPresent": "The internet is working well today.",
        "examplePast": "Gestern hat der Drucker nicht funktioniert.", "translationPast": "Yesterday the printer did not work.",
        "exampleFuture": "Alles wird morgen wieder funktionieren.", "translationFuture": "Everything will work again tomorrow."
    },
    {
        "german": "kaputt", "english": "broken", "level": "A2", "category": "Daily Life",
        "example": "Mein Auto ist kaputt.",
        "examplePresent": "Die Waschmaschine ist kaputt.", "translationPresent": "The washing machine is broken.",
        "examplePast": "Die Brille war gestern kaputt.", "translationPast": "The glasses were broken yesterday.",
        "exampleFuture": "Das Handy wird bald kaputt sein.", "translationFuture": "The mobile phone will soon be broken."
    },
    {
        "german": "reparieren", "english": "to repair", "level": "A2", "category": "Daily Life",
        "example": "Kannst du mein Fahrrad reparieren?",
        "examplePresent": "Ich repariere gerade den Tisch.", "translationPresent": "I am repairing the table right now.",
        "examplePast": "Er hat sein Auto selbst repariert.", "translationPast": "He repaired his car himself.",
        "exampleFuture": "Der Handwerker wird den Schaden morgen reparieren.", "translationFuture": "The craftsman will repair the damage tomorrow."
    },
    {
        "german": "die Werkstatt", "english": "workshop", "level": "A2", "category": "Daily Life",
        "example": "Mein Auto ist in der Werkstatt.",
        "examplePresent": "Die Werkstatt ist heute voll.", "translationPresent": "The workshop is full today.",
        "examplePast": "Die Werkstatt war am Wochenende geschlossen.", "translationPast": "The workshop was closed at the weekend.",
        "exampleFuture": "Ich werde mein Auto in die Werkstatt bringen.", "translationFuture": "I will bring my car to the workshop."
    },
    {
        "german": "das Werkzeug", "english": "tool", "level": "A2", "category": "Daily Life",
        "example": "Wo ist mein Werkzeug?",
        "examplePresent": "Das Werkzeug liegt im Keller.", "translationPresent": "The tool is lying in the cellar.",
        "examplePast": "Das Werkzeug war rostig.", "translationPast": "The tool was rusty.",
        "exampleFuture": "Ich werde mir neues Werkzeug kaufen.", "translationFuture": "I will buy new tools."
    },
    {
        "german": "die Hilfe", "english": "help", "level": "A2", "category": "Daily Life",
        "example": "Vielen Dank für deine Hilfe.",
        "examplePresent": "Ich brauche dringend Hilfe.", "translationPresent": "I need help urgently.",
        "examplePast": "Die Hilfe kam gerade noch rechtzeitig.", "translationPast": "The help arrived just in time.",
        "exampleFuture": "Wir werden Hilfe rufen.", "translationFuture": "We will call for help."
    },
    {
        "german": "danken", "english": "to thank", "level": "A2", "category": "Social",
        "example": "Ich danke dir für alles.",
        "examplePresent": "Er dankt seinen Gästen.", "translationPresent": "He thanks his guests.",
        "examplePast": "Sie hat mir gestern für das Geschenk gedankt.", "translationPast": "She thanked me yesterday for the gift.",
        "exampleFuture": "Ich werde ihm später danken.", "translationFuture": "I will thank him later."
    },
    {
        "german": "gratulieren", "english": "to congratulate", "level": "A2", "category": "Social",
        "example": "Ich gratuliere dir zum Geburtstag.",
        "examplePresent": "Wir gratulieren dem Brautpaar.", "translationPresent": "We congratulate the bridal couple.",
        "examplePast": "Er hat mir gestern zur bestandenen Prüfung gratuliert.", "translationPast": "He congratulated me yesterday on passing the exam.",
        "exampleFuture": "Ich werde ihr morgen zum Erfolg gratulieren.", "translationFuture": "I will congratulate her tomorrow on the success."
    },
    {
        "german": "die Freude", "english": "joy", "level": "A2", "category": "Feelings",
        "example": "Das ist eine große Freude.",
        "examplePresent": "Die Freude ist riesig.", "translationPresent": "The joy is huge.",
        "examplePast": "Die Freude war gestern getrübt.", "translationPast": "The joy was dampened yesterday.",
        "exampleFuture": "Es wird eine große Freude für uns alle sein.", "translationFuture": "It will be a great joy for all of us."
    },
    {
        "german": "die Angst", "english": "fear", "level": "A2", "category": "Feelings",
        "example": "Ich habe Angst vor Spinnen.",
        "examplePresent": "Die Angst lässt langsam nach.", "translationPresent": "The fear is slowly subsiding.",
        "examplePast": "Er hatte große Angst während des Gewitters.", "translationPast": "He was very afraid during the thunderstorm.",
        "exampleFuture": "Du wirst keine Angst haben müssen.", "translationFuture": "You will not have to be afraid."
    },
    {
        "german": "wütend", "english": "angry", "level": "A2", "category": "Feelings",
        "example": "Warum bist du so wütend?",
        "examplePresent": "Er ist wütend über die Verspätung.", "translationPresent": "He is angry about the delay.",
        "examplePast": "Sie war gestern sehr wütend auf mich.", "translationPast": "She was very angry with me yesterday.",
        "exampleFuture": "Niemand wird wütend sein.", "translationFuture": "Nobody will be angry."
    },
    {
        "german": "nervös", "english": "nervous", "level": "A2", "category": "Feelings",
        "example": "Ich bin vor der Prüfung nervös.",
        "examplePresent": "Er wirkt heute sehr nervös.", "translationPresent": "He seems very nervous today.",
        "examplePast": "Sie war gestern vor dem Interview nervös.", "translationPast": "She was nervous yesterday before the interview.",
        "exampleFuture": "Du wirst sicher nicht nervös sein.", "translationFuture": "You will certainly not be nervous."
    },
    {
        "german": "vorsichtig", "english": "careful", "level": "A2", "category": "Feelings",
        "example": "Sei vorsichtig auf der Straße.",
        "examplePresent": "Ich bin vorsichtig beim Fahren.", "translationPresent": "I am careful while driving.",
        "examplePast": "Er war gestern sehr vorsichtig.", "translationPast": "He was very careful yesterday.",
        "exampleFuture": "Ich werde in Zukunft vorsichtiger sein.", "translationFuture": "I will be more careful in the future."
    },
    {
        "german": "gefährlich", "english": "dangerous", "level": "A2", "category": "Nature",
        "example": "Das ist ein gefährliches Tier.",
        "examplePresent": "Die Situation ist gefährlich.", "translationPresent": "The situation is dangerous.",
        "examplePast": "Der Weg war gestern gefährlich glatt.", "translationPast": "The path was dangerously slippery yesterday.",
        "exampleFuture": "Es wird dort nicht gefährlich sein.", "translationFuture": "It will not be dangerous there."
    },
    {
        "german": "sicher", "english": "safe/sure", "level": "A2", "category": "Feelings",
        "example": "Bist du dir sicher?",
        "examplePresent": "Das Haus ist sicher.", "translationPresent": "The house is safe.",
        "examplePast": "Er war sich seiner Sache sicher.", "translationPast": "He was sure of his case.",
        "exampleFuture": "Ich werde sicher bald da sein.", "translationFuture": "I will surely be there soon."
    },
    {
        "german": "pünktlich", "english": "punctual", "level": "A2", "category": "Daily Life",
        "example": "Bitte sei pünktlich.",
        "examplePresent": "Der Zug ist heute pünktlich.", "translationPresent": "The train is punctual today.",
        "examplePast": "Er war gestern leider nicht pünktlich.", "translationPast": "He was unfortunately not punctual yesterday.",
        "exampleFuture": "Ich werde pünktlich zum Treffen erscheinen.", "translationFuture": "I will show up punctually for the meeting."
    },
    {
        "german": "fleißig", "english": "diligent", "level": "A2", "category": "Education",
        "example": "Die Schüler sind sehr fleißig.",
        "examplePresent": "Ich bin fleißig beim Lernen.", "translationPresent": "I am diligent in studying.",
        "examplePast": "Er war früher ein fleißiger Student.", "translationPast": "He used to be a diligent student.",
        "exampleFuture": "Du wirst fleißig sein müssen.", "translationFuture": "You will have to be diligent."
    },
    {
        "german": "faul", "english": "lazy", "level": "A2", "category": "Feelings",
        "example": "Heute bin ich ein bisschen faul.",
        "examplePresent": "Der Kater ist faul.", "translationPresent": "The tomcat is lazy.",
        "examplePast": "Ich war am Sonntag faul.", "translationPast": "I was lazy on Sunday.",
        "exampleFuture": "Morgen werde ich nicht faul sein.", "translationFuture": "Tomorrow I will not be lazy."
    },
    {
        "german": "höflich", "english": "polite", "level": "A2", "category": "Social",
        "example": "Er ist immer sehr höflich.",
        "examplePresent": "Das Kind ist höflich zu den Lehrern.", "translationPresent": "The child is polite to the teachers.",
        "examplePast": "Sie war gestern sehr höflich zu mir.", "translationPast": "She was very polite to me yesterday.",
        "exampleFuture": "Ich werde höflich nach dem Weg fragen.", "translationFuture": "I will ask politely for the way."
    }
]

def add_words():
    if not os.path.exists(existing_words_file):
        print(f"Error: {existing_words_file} not found")
        return

    with open(existing_words_file, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")
            return

    seen = set(item['german'] for item in data)

    unique_new_words = []
    for word in new_words:
        if word['german'] not in seen:
            unique_new_words.append(word)
            seen.add(word['german'])

    data.extend(unique_new_words)

    with open(existing_words_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"Added {len(unique_new_words)} words to {existing_words_file}")

if __name__ == "__main__":
    add_words()
