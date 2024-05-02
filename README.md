##  ComprasUSACaseStudy

**This project in a work in progress**

This is a project to practice iOS skills. It is a remastered version of the [ComprasUSA](https://github.com/MarcosApostolo/ComprasUSA) project that was the solution to a code challenge I had during my MBA graduation.

It's purpose is to allow users to register purchases they made during their trip to the USA and check the total amount they spent considering taxes for each state and Brazilian taxes on financial transactions (iof) as well as the dollar value.

This remastered version contains the following improvements over the older project:

- Reliable, fast and comprehensive tests to validate the business rules, allow for fast feedback and quick regressions
- Mainly developed following Test Driven Development practices
- Modular design principles
- Test driven UI development with integration tests and snapshot tests
- UI development with viewcode
- Use of modern tools such as Combine
- Clear separation of the presentation module using the MVVM UI design pattern

This project is being developed
Plans for the future:

- Adopt SwiftUI to replace gradually UIKit implementations
- Experiement with other tools such as RxSwift, Realm, etc.

### Project Structure

#### ComprasUsaCaseStudy

- Domain module containing UseCases and CoreData implementation.

#### ComprasUSAiOS

- iOS specific module containing all ViewControllers, Views and Presentation classes (ViewModels).

#### ComprasUSACaseStudyApp

- iOS App that serves as Composition Root to compose all modules 

