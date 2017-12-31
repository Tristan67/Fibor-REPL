# Fibor-REPL
An iOS app to exercise and demonstrate the functionality of the [Fibor framework](https://github.com/Tristan67/Fibor). 


## Download the App Project
1. Download the project. 
2. Open the Xcode project file ("Fibor-REPL.xcodeproj") with Xcode. 


## Download the Fibor Framework
1. Download the Fibor framework project located [here](https://github.com/Tristan67/Fibor). 
2. Open the downloaded folder in Finder and navigate to "Fibor.xcodeproj".


## Link the App and Framework
1. In the Navigation area of the Xcode window, delete the sub Xcode project called "Fibor.xcodeproj". 
![img1](https://github.com/Tristan67/Fibor-REPL/blob/master/img1.png)
2. Drag the "Fibor.xcodeproj" file from Finder under the "Fibor-REPL.xcodeproj" in the Navigation area. 
![img2](https://github.com/Tristan67/Fibor-REPL/blob/master/img2.png)
3. Click on the "Fibor-REPL.xcodeproj" file. 
4. In the Editor area, select the Fibor REPL target and select the General tab at the top. 
5. In the Navigation area, navigate to the "Fibor.framework" (Fibor.xcodeproj > Products > Fibor.framework). 
6. Drag the "Fibor.framework" to the Embedded Binaries section in the Editor area. 
![img3](https://github.com/Tristan67/Fibor-REPL/blob/master/img3.png)
7. The framework will also show up under Linked Frameworks and Binaries. 
8. The projects are linked and the App is ready to build and run! 


## Using the App
When the app launches, there are 3 options: 

### Definitions 
When this cell is hit, a text editor opens a file with some pre-set code. Fibor *definitions* (class and extensions) written here will be injected into the virtual Fibor context. Any changes to this file are auto-saved and persistant between app launches. 

### Statements
Hitting this cell shows another text editor with a file opened with some pre-set code. Fibor *statements* (var, if, while, do, etc.) written in this file will automatically be performed at the beginning of each run of a Fibor context, but after the definitions have been injected. Again, any changes to this file are auto-saved and persistant between app launches. 

### Run REPL
Upon hitting this cell a virual Fibor context is initialized, the definitions and statements from above are injected and performed, and a GUI is displayed for inserting more Fibor statements one at a time. 
The **Store** button at the top left of the window can be clicked do display a visual representation of the current Fibor context's store. The store is update in real time and can be viewed inbetween performing statements to see how said statements affect the store. 
(It should be noted that this app is not quite a REPL yet, as nothing is printed to the screen except user written statements. However, this makes sense since the user writes *statements*, not *expressions*). 
