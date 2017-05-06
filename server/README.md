## HyLionPost - Server Part

### [Build Instruction Before Make Server-side](https://firebase.google.com/docs/ios/setup)

On Mac OS X with Xcode & swift 3.0

Using FIREBASE server & database Framework

우선적으로 구글의 Firebase를 사용하기 위해서 pod 설정해야 한다.

~~~reStructuredText
$ sudo gem install cocoapods
$ pod setup
~~~

이 과정을 통해 개발 컴퓨터에 pod가 설치 된다. 

다음은 당신이 제작한 iOS 앱에 Firebase와 연관된 파일을 설치하고 Firebase에 핵심 Core 파일을 연결하는 과정이다. 먼저, 당신이 개설한 xcodeproject 파일이 있는 곳에서 다음의 명령어를 입력한다.

~~~
$ pod init
~~~

이를 입력하면 프로젝트가 있는 폴더 내부에 Podfile이 생성됩니다.

이 부분이 완료되면 생성된 Podfile을 아래 명령어를 통해 text 파일로 연다.

~~~reStructuredText
$ open -e Podfile
~~~

열린 파일 중간에 `pod 'Firebase/Core'` 라고 입력합니다. 이는 `pod` 명령어를 이용해 자동으로 install 되는 package 에 헤당합니다.

~~~text
$ pod install
Analyzing dependencies
Downloading dependencies
Installing Firebase (3.17.0)
Installing FirebaseAnalytics (3.9.0)
Installing FirebaseCore (3.6.0)
Installing FirebaseInstanceID (1.0.10)
Installing GoogleToolboxForMac (2.1.1)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `ServerTestProject.xcworkspace` for this project from now on.
Sending stats
Pod installation complete! There is 1 dependency from the Podfile and 5 total pods installed.

[!] Smart quotes were detected and ignored in your Podfile. To avoid issues in the future, you should not use TextEdit for editing it. If you are not using TextEdit, you should turn off smart quotes in your editor of choice.

[!] Automatically assigning platform ios with version 10.3 on target ServerTestProject because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.
~~~

명령어를 입력하면  위와 같이 설치가 됩니다.

이제 자신이 개발할 iOS 애플리케이션 project의 bundle identifier에 적힌 bundle id를 복사해서 Firebase에 적용시킵니다.

이를 통해 생성된 `GoogleService-Info.plist`  파일을 다운로드 하여 xcodeproject root directory에 이동시킵니다.

이후에 `Appdelegate.swift` 파일에 `import Firebase` 와 아래와 같이 `FIRApp.configure()` 코드를 삽입합니다.

~~~swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure() // <- New code about Firebase
        return true
    }
~~~

이로써 서버 생성 준비 끝 !

### [Add a Real-time Database](https://firebase.google.com/docs/database/ios/start) 

디비를 써보자!

~~~
pod 'Firebase/database'
~~~

제시된 줄을 Podfile 파일에 입력합니다. `pod install` 을 입력하면 아래와 같이 나타납니다.

~~~
$ pod install
Analyzing dependencies
Downloading dependencies
Installing Firebase 3.17.0 (was 3.17.0) // new install
Using FirebaseAnalytics (3.9.0)
Using FirebaseCore (3.6.0)
Installing FirebaseDatabase (3.1.2) // new install
Using FirebaseInstanceID (1.0.10)
Using GoogleToolboxForMac (2.1.1)
Generating Pods project
Integrating client project
Sending stats
Pod installation complete! There are 2 dependencies from the Podfile and 6 total pods installed.

[!] Smart quotes were detected and ignored in your Podfile. To avoid issues in the future, you should not use TextEdit for editing it. If you are not using TextEdit, you should turn off smart quotes in your editor of choice.

[!] Automatically assigning platform ios with version 10.3 on target ServerTestProject because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.
~~~

