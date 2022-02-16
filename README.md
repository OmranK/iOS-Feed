[![CI](https://github.com/OmranK/iOSApp-Feed-FrontEnd/actions/workflows/CI.yml/badge.svg)](https://github.com/OmranK/iOSApp-Feed-FrontEnd/actions/workflows/CI.yml)

# Feed - iOS Front End Application 

### On the surface 
A simple iOS app that loads and displays images in the users feed.

### Under the hood 
The application of high level concepts of software design and architecture such as Dependency Inversion, Clean Architecture, Version Control, Continuous Integration, and more to the process of engineering an iOS mobile application with modular components that are decoupled from one another and are easy to refactor or replace. 

Following the principles of TDD, all components are continously tested in 
isolation via unit tests, allowing us to ensure that correct behaviors are achieved, programming mistakes are caught, and data races and memory leaks are protected against. Maintenanability is guaranteed in perpetuity by integration tests, version control, and the continuous integration pipeline. This ensures the codebase is highly predictable, easy to refactor and even easier to understand.


## Learning Outcomes

Documentation of knowledge gained or refined during the process.

- git 
  	- branching + rebasing
   	- merging + resolving merge conflicts
   	- using local and remote repos for a safe development process
   	- pull requests on github
- CI
   	- using github actions for running tests prior to merging a pull requests
   	- integration tests
   	- end to end tests
- Foundation's URL Loading System
	- `URLSession`, `URLSessionTask`, `URLSessionConfiguration`
	- The `URLProtocol` abstract class and how to use it to intercept network calls and simulate responses during testing.
- CoreData
	- The Stack - `NSManagedObjectModel`, `NSPersistentStoreCoordinator`, `NSManagedObjectContext`
	- The Persistent Container - `NSPersistentContainer`
	- Entities, Properties, and Relationships
	- Object data models - `NSManagedObject` subclasses