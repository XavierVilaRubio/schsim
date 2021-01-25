# 102377-Challenge3-SCHSIM

## About ##

| Title:     | Challenge 3: SCHSIM |
| ---------- | -------------------------                    |
| Author:     | [Xavier Vila Rubio](http:xavi.sx)                            |
| Instructor: | [Jordi Mateo Fornés](http:jordimateofornes.com) |
| *Fall*: | 2020-2021                                                    |
| *Course*:    |    102377 - Operating Systems - [Grau en Tècniques d'Interacció Digital i de Computació](http://www.grauinteraccioicomputacio.udl.cat/ca/index.html) |
| University:     | [University of Lleida](http://www.udl.cat/ca/) - [Campus Igualada](http://www.campusigualada.udl.cat/ca/) - [Escola Politècnica Superior](http://www.eps.udl.cat/ca/)       |
| Copyright: | Copyright © 2019-2020 Xavier Vila Rubio |
| Version: | 1.0 |

---

### Table of Contents
- [Scope](#scope)
- [Strategy](#strategy)
- [Organization](#organization)
- [How To Use](#how-to-use)

---

## Scope
One of the many responsibilities of a timesharing operating system is to provide each running program with its "fair" share of the CPU time. We have studied different algorithms to determine when a process should be allowed to run.

## Strategy
To solve this challenge we've created an interface with Flutter, and coded using Dart the algorithms. For the algorithm implementation we created two classes: dispacher (the scheduler) and process, this way we can treat eche process with his properties. 

#### Technologies

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [GitHub Actions](https://github.com/features/actions)
- [Firebase](https://firebase.com/)

## Organization
* **lib/**: This folder contains the code written.
  * *main.dart*: The main code to run the aplication.
* **lib/algorithms**: This folder contains the code written.
  * *dispacher.dart*: The code for the dispacher class.
  * *process.dart*: The code for the process class.
* **lib/screens**: This folder contains the code written.
  * *formScreen.dart*: The code for the form screen..
  * *resultsScreen.dart*: The code for the results screen.

---

## How To Use

#### [Web-App](https://schsim-52f53.web.app/#/)

#### Locally
To compile and use this code in your computer you need to switch to flutter beta channel and run this inside the project folder:
```bash
flutter channel beta
flutter upgrade
flutter config --enable-web
flutter create .
```
And then, to run into chrome:
``flutter run -d chrome``


[Back To The Top](#read-me-template)
