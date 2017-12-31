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
