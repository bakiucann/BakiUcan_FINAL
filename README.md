# myTunes App

<img width="250" alt="mytunes" src="https://github.com/bakiucann/BakiUcan_FINAL/assets/113190194/fcaf3a29-99e3-4401-a645-9d188cff3a9c">

`myTunesApp` is a highly dynamic and user-friendly music search application crafted in Swift. The application permits users to search for their beloved songs and include them in their favorite list. This application exhibits a well-structured VIPER (View-Interactor-Presenter-Entity-Router) architecture to ensure an organized, maintainable, and testable codebase.

## Features


**1. Song Search:** Enables users to explore their favorite tracks using the search functionality.

**2. Favorites Management:** Users can effortlessly add their desired songs to a favorites list for future access.

**3. Detailed Song View:** Users can access comprehensive details about their favorite songs.

**4. Continuous Playback:** The app supports uninterrupted playback of the selected songs.

**5. Intuitive UI:** Provides a user-friendly interface that is extremely easy to navigate and visually pleasing.

## Project Architecture

The architecture of the project adheres to the VIPER design pattern to ensure a high degree of separation of concerns, leading to a more manageable and scalable application.

- **View:** Displays what it is told to by the Presenter and relays user input back to the Presenter.
- **Interactor:** Contains the business logic as specified by a use case.
- **Presenter:** Contains view logic for preparing content for display and for reacting to user inputs.
- **Entity:** Contains basic model objects used by the Interactor.
- **Router:** Contains navigation logic for describing which screens are shown in which order.

## Testing

`myTunesApp` incorporates a robust suite of unit and UI tests, ensuring that the application is reliable and offers a high-quality user experience.

- **Unit Tests:** The unit tests are designed to evaluate individual components in isolation, including the Interactor and Presenter.
- **UI Tests:** The UI tests simulate user interactions with the application and verify the application's appropriate response.

## Installation

Follow the steps below to setup this project locally:

1. Clone the repository using this command: `git clone https://github.com/bakiucann/BakiUcan_FINAL.git`
2. Navigate into the project directory: `cd BakiUcan_FINAL`
3. Open the project in Xcode: `open BakiUcan_FINAL.xcodeproj`
4. Finally, run the application: `Cmd + R`

## Requirements

- Swift 5.0 or above
- iOS 13.0 or above
- Xcode 11.0 or above

## Videos and Images

Here are some screenshots and video walkthroughs of the application in action:

<img src="https://github.com/bakiucann/BakiUcan_FINAL/assets/113190194/ed3a625c-e4d3-4fa4-8faf-e4a156f40ca7" width="200" />
<img src="https://github.com/bakiucann/BakiUcan_FINAL/assets/113190194/98b4c327-199d-42cc-8f21-6ee8429aabc7" width="200" />
<img src="https://github.com/bakiucann/BakiUcan_FINAL/assets/113190194/79f542ec-4f83-4864-815c-f8207da57541" width="200" />
<img src="https://github.com/bakiucann/BakiUcan_FINAL/assets/113190194/6886f209-1b0d-4b8a-9c07-7f5e20d77e78" width="200" />


For a more interactive overview, check out these video demos:


https://github.com/bakiucann/BakiUcan_FINAL/assets/113190194/74947646-2236-43e6-844e-b81cec3d63dd



## Contributing

The project is developed and maintained by `Baki Uçan`. If you would like to contribute or have any questions, please reach out at on GitHub.

## License

`myTunesApp` is open source and available under the MIT license. For more details, refer to the `LICENSE` file.

## Project Link

You can find the project repository here: [https://github.com/bakiucann/BakiUcan_FINAL](https://github.com/bakiucann/BakiUcan_FINAL)
