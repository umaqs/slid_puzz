## Inspiration
I wanted to create something beautiful yet functional for this hackathon and test the limits of Flutter Web along the way.
## What it does
 **slidpuzz** is packed with a variety of game modes, features and beautiful themes.
Some of the prominent features are:
- **Modes:** Classic numbers puzzle, words and pictures.
- **Grids:** classic square grid and hexagonal grid.
- **Difficulty levels:** easy, medium, difficult and inferno.
- **Auto solver:** Leveraging extended A-Star algorithm to solve all the puzzles.
- **Themes:** 18 beautiful themes including light and dark mode.

### Pictures mode:
- Pictures menu represents 16 random pictures (Lorem Picsum) to pick from. The available images can be refreshed.
- User can also upload an image from device storage or camera.
- There is a search feature to load a picture based on the **search term** (using Unsplash).
- Search term is passed on to the puzzle screen as query param and each subsequent refresh of the page loads a random picture for that search term.

### Words Mode:
- In both square grid and hex grid, each row makes a word.
- From a shuffled state, users can arrange the letters to spell any valid words (according to the available dictionary) to count the completed state. e.g: both FORM and FROM are acceptable combinations in a 4x4 puzzle.
---
## How we built it
I started off with the demo project provided by VGV (thank you Bart+team) but ended up starting from scratch as I needed more control over the state + navigation. Some code for the puzzle logic still comes from very_good_puzzle, but here are the details for the rest:

### User Interface:
- Every game mode has its own screen, which is built following the layout delegate pattern.
- I used [go_router](https://pub.dev/packages/go_router) to support deep linking and URL matching for the web.
- The app UI is responsive and works well on different screen sizes.
- There are 9 themes for each brightness (light/dark) along with the option to follow the system brightness. The app will remember this preference.
- The app has beautiful animation for loading states, tile hover and sliding.

### Showcase
|Animations||
| -----------|---|
| ![Hover animation](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/gifs/hover_animation.gif) | ![Tile sliding animation](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/gifs/hover_animation.gif)|
| ![Pictures Menu](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/gifs/picture_menu_animation.gif) | ![Pictures Puzzle](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/gifs/picture_puzzle_animation.gif)|

|Screenshots||
| -----------|-|
| ![Theme brightness](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/images/themes-brightness.png) | ![Themes menu](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/images/themes-menu.png)|
| ![Square puzzles](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/images/square-grid.png) | ![Pictures Puzzle](https://raw.githubusercontent.com/umaqs/slid_puzz/main/showcase/images/hex-grid.png)|

### State management:
- The state is managed using ChangeNotifier + Provider. 
- There is a base PuzzleGameNotifier which is extended by different game modes like SquarePuzzleNotifier and HexPuzzleNotifier. These 2 notifiers manage the game state machine and are further extended to be used for specific cases like pictures game and words game.

## Challenges I ran into
- Since Isolates are not available for Flutter Web, cropping image to an NxN grid using the [image](https://pub.dev/packages/image) package was freezing the UI for a good few seconds. I explored different options including the use of [dart:html](https://api.dart.dev/stable/2.16.1/dart-html/dart-html-library.html) and Canvas API to crop the image but ended up using CustomPainter to draw a part of the image.
- Similar issue with puzzle solver algorithm, A-Star has exponential time and space complexity, while it works fairly quick for 3x3 puzzle, 4x4 puzzle was taking some time to solve it, 5x5 and 6x6 grids were taking up to few minutes to find a solution. To work around this, I implemented a greedy version that provides the best available solution within a time threshold, use that solution to partially solve the puzzle, and run the algorithm again with a reduced threshold time. This resulted in an eventual solution for the 4x4 and 5x5 and 6x6 grid as well as hex puzzles without freezing the UI.

## Accomplishments that I am proud of
Between UI design and animation, different game modes and auto-solver implementation, this whole project was a good learning experience. I managed to complete a good set of features in a limited time and it gives me the motivation to continue working on this project.

## What I learned
slidpuzz is my first Flutter Web project and I got to try a few web development concepts in the realm of Flutter. A few things to highlight:
- Responsive UI design using MediaQuery and breakpoints.
- Angular style routing, deep linking, and route-guards/redirecting with the help of the go_router package.
- Working with asset loading and local storage for the web.
- Different kinds of web renderers that are available in Flutter, with their pros and cons.
- Dart compilers for web apps: dartdevc and dart2js.

Learnt about limitations of Flutter Web when it comes to static document-based web pages and SEO, lack of isolates support and performance issues while running PWA on iOS Safari.

## What's next for slidpuzz
The project has a lot of room for improvement. Following is a list of features/improvements that I will be working on in the coming months:

- Hex grid puzzle for pictures mode.
- Leaderboards for each game mode and multiplayer game option.
- Feature to generate custom words puzzle and share it as a challenge.
- Adding web workers support to run computation heavy tasks like A-Star.
- Tests with full coverage.
- Releasing the app to the App Store
