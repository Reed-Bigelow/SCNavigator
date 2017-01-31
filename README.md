# SCNavigator
Remake of Snapchats new navigation Controller

![](http://i.giphy.com/Su5XgdcfbVqcE.gif)

Create ViewController : 
```
class TestViewController: SCNavigatorViewController{
    override func setupView() {
        datasource = self
    }
}
```
Add Extension :

```
extension TestViewController : SCNavigationDataSource
{
    public func ViewControllers() -> [UIViewController] {
    
        let LeftVC      = UIViewController()
        let RightVC     = UIViewController()
        let BottomVC    = UIViewController()
        let TopVC       = UIViewController()
        let CenterVC    = UIViewController()
        
        return [LeftVC,RightVC,BottomVC,TopVC,CenterVC]
    }
}
```

Present Controller: (In AppDelegate)
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var window: UIWindow?
        
        self.window?.rootViewController? = TestViewController()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
```
Move To Page :

```
class TestViewController: SCNavigatorViewController{
    override func setupView() {
        datasource = self
        
        self.MoveToPage(with: 1)
    }
}
```
