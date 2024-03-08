# Wordle Plus

_Personal project using the [Haskell](https://www.haskell.org/) web framework [Yesod](https://www.yesodweb.com/)_

### Criteria for choosing said technology:

- _`Speed`_ - By using Haskell's **GHC compiler**, we can analyze and optimize HTML, CSS and JavaScript code at compile time
- _`Robustness`_ - Haskell's inherent **type system** allows for internal consistency. Yesod particularly shines at **routing/dispatch** and integrates well with Persistent, an universal data store interface. We also get all the benefits of functional programming; for example: **minimizing side effects**, accounting for all possible cases via **pattern matching**, more concise and readable code, modularity
- _`Safety`_ - Yesod itself deals with multiple vulnerabilities. Some of those it completely avoids, like **XXS attacks** (via variable interpolation) or **SQL-injection** (with type-safe database actions). There are many built-in features that adress other concerns (notably the Form package has great validation options and also prevents **CSRF**)

### Documentation

_Many files are the setup for Yesod's scaffolded site so here is a quick guide for navigating the project:_

> Routing - [/config/routes.yesodroutes](https://github.com/VSebastian8/Wordle-in-Haskell/blob/main/config/routes.yesodroutes)
>
> Models - [/config/models.persistentmodels](https://github.com/VSebastian8/Wordle-in-Haskell/blob/main/config/models.persistentmodels) (database entities)
>
> Shakespeare template languages - [/templates](https://github.com/VSebastian8/Wordle-in-Haskell/tree/main/templates) (Hamlet, Cassius & Julius for HTML, CSS & JavaScript)
>
> Handlers for route requests [/src/Handler](https://github.com/VSebastian8/Wordle-in-Haskell/tree/main/src/Handler) (most project-relevant haskell code lives here)

### Backlog

- [x] text input
  - type new letter
  - delete letter
  - enter word
- [x] displayed keyboard
- [x] user keyboard
- [x] boxes styling
- [x] boxes colors
- [ ] boxes animation
- [x] enter word request and response
- [x] server validation
- [x] error handling
- [x] remember current guesses in session
- [ ] function for guess match against answer
- [ ] handle game ending
- [ ] import word list
- [ ] login
- [ ] save game in database
- [ ] infinite mode
- [ ] statistics
  - average number of guesses
  - progress in time
  - hardest words to guess (for all players)
- [ ] searchbar for remaining words
- [ ] send game png to email
- [ ] custom word list
- [ ] wikipedia web scraping for 5 letter word list
- [ ] wordle bot using entropy
