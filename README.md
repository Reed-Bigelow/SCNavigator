# SCNavigator
Remake of Snapchats new navigation Controller

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
        let view1 = UIViewController()

        let view2 = UIViewController()
        
        let view3 = UIViewController()
        let view4 = UIViewController()

        return [view1,view2,view3,view4]
    }
}
```
