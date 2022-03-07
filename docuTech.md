# Documentation Technique
Cette documentation reprend tout le nécessaire pour comprendre les appels API utilisés avec DRAW ( framework Flutter pour Reddit API)

# Utilisation de l'API de Reddit

## Mise en place pour faire des requêtes API:
Tout d'abord, vous avez besoin d'un identifiant et d'un secret d'application pour que Reddit connaisse votre application. Vous obtenez ces informations en allant sur https://www.reddit.com/prefs/apps et en cliquant sur "are you a developer ? create an app..."

#### Exemple:
 
![Exemple RedditAPI](https://camo.githubusercontent.com/98b9844a49d3ac72cbabaa394069349c22a84bb68304668c47a0ad61f5c63416/687474703a2f2f692e696d6775722e636f6d2f65326b4f5231612e706e67)à noter que ce n'est qu'un exemple à titre démonstratif, aucun token propre à l'application Unsharped ne sera montré dans cette documentation publique.

#### Récupération du Token et Autorisation de l'utilisateur:
  Nous devons acquérir un token d'autorisation, pour récupérer les données de l'utilisateur, ce dernier doit faire savoir à Reddit qu'il est d'accord pour que votre application effectue certaines actions pour lui, comme lire ses abonnements aux subreddits ou envoyer un message privé.
Pour se faire, on envoie l'URL suivante: 

  ```
https://www.reddit.com/api/v1/authorize?client_id=CLIENT_ID&response_type=TYPE&
    state=RANDOM_STRING&redirect_uri=URI&duration=DURATION&scope=SCOPE_STRING
```
Lorsqu'on l’utilisateur est redirigé vers ce lien, il reçoit une liste des informations que l'application souhaite obtenir sur son profil.
 #### Par exemple: 
![exemple autorisation token](https://camo.githubusercontent.com/71b93597ee8af39ee5533634416c28ed42089b8fe40ca29a59435fea7abd75a5/687474703a2f2f692e696d6775722e636f6d2f3175666845774e2e706e67)
Bien sûr, l'application demande d'avantage d'informations que le simple pseudo de la personne!

Il faut que l'utilisateur accepte, sinon on ne pourra pas obtenir les infos et notamment le bearer token qui permettra de faire des requêtes API. 

### Récupération du token utilisateur 
Si il n'y a pas eu d'erreur, normalement on peut récupérer le token de notre utilisateur en faisant une requête POST sur cette adresse : 

   ```
https://www.reddit.com/api/v1/access_token
```

On obtient alors une réponse sous format Json : 
```
{
    "access_token": Le token utilisateur,
    "token_type": "bearer",
    "expires_in": Unix Epoch Seconds,
    "scope": un scope ( i.e ce que l'on a demandé d'accepter à l'utilisateur),
    "refresh_token": Le token pour rafraichir.
}
```
Une fois ces infos obtenus, on peut passer sur DRAW pour faire nos requêtes API de façon simplifiée.

## Utilisation de DRAW pour les requêtes

DRAW ( Dart Reddit API Wrapper) permet de nous simplifier le travail de requête avec des modules préparés. 

### Exemple de requêtes API avec DRAW
 
 #### Récupérer un nom d'utilisateur
```dart
import 'dart:async';
import 'package:draw/draw.dart';

Future<void> main() async {
  // Create the `Reddit` instance and authenticated
  Reddit reddit = await Reddit.createScriptInstance(
    clientId: CLIENT_ID,
    clientSecret: SECRET,
    userAgent: AGENT_NAME,
    username: "DRAWApiOfficial",
    password: "hunter12", // Fake
  );

  // Retrieve information for the currently authenticated user
  Redditor currentUser = await reddit.user.me();
  // Outputs: My name is DRAWApiOfficial
  print("My name is ${currentUser.displayName}");
}
```

