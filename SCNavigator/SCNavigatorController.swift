//
//  SCNavigatorController.swift
//  SCNavigator
//
//  Created by Reed Bigelow on 1/27/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

//
//  ViewController.swift
//  Test
//
//  Created by Reed Bigelow on 1/26/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

@objc public protocol SCNavigationDataSource {
    func ViewControllers()                    ->  [UIViewController]
    @objc optional func IndexOfStartingPage() ->  Int
    @objc optional func BackgroundColor()     ->  [UIColor]
    @objc optional func MoveTo(with PageNumber: Int) // Left 0 : Right 1 : Bottom 2 : Top 3
}

enum VCPage : Int
{
    case LeftVC
    case RightVC
    case BottomVC
    case TopVC
    case CenterVC
}

enum BackColor : Int
{
    case Purple
    case Blue
    case Red
    case Clear
}

open class SCNavigatorController: UIViewController{
    
    //MARK : Constants
    public struct constants
    {
        public static var Orientation: UIInterfaceOrientation {
            return UIApplication.shared.statusBarOrientation
        }
        public static var ScreenWidth : CGFloat {
            return UIScreen.main.bounds.width
        }
        public static var ScreenHeight : CGFloat {
            return UIScreen.main.bounds.height
        }
        public static var StatusBarHeight : CGFloat {
            return UIApplication.shared.statusBarFrame.height
        }
        public static var ScreenBounds : CGRect {
            return UIScreen.main.bounds
        }
    }
    
    //MARK : Page Finish Opening Acuation point
    fileprivate func PageActuationPoint(ViewController : VCPage) -> Float {
        switch ViewController {
        case .LeftVC:
            return Float(constants.ScreenWidth / 2)
        case .RightVC:
            return Float(constants.ScreenWidth * 1.5)
        case .BottomVC:
            return Float(constants.ScreenHeight * 1.5)
        case .TopVC:
            return Float(constants.ScreenHeight / 2)
        default:
            return Float(constants.ScreenWidth)
        }
    }
    
    //MARK Screen View Locations
    fileprivate func PageViewPoint(ViewController : VCPage) -> CGPoint {
        switch ViewController {
        case .LeftVC:
            return CGPoint(x: 0, y: constants.ScreenHeight)
        case .RightVC:
            return CGPoint(x: constants.ScreenWidth * 2, y: constants.ScreenHeight)
        case .BottomVC:
            return CGPoint(x: constants.ScreenWidth, y: constants.ScreenHeight * 2)
        case .TopVC:
            return CGPoint(x: constants.ScreenWidth, y: 0)
        case .CenterVC:
            return CGPoint(x: constants.ScreenWidth, y: constants.ScreenHeight)
        }
    }
    
    //MARK : Return Background Color
    fileprivate func ScrollViewColor(BackColor : BackColor) -> UIColor{
        switch BackColor {
        case .Blue:
            return UIColor.init(colorLiteralRed: 60/255,  green: 178/255, blue: 226/255, alpha: 1.0)
        case .Purple:
            return UIColor.init(colorLiteralRed: 155/255, green: 85/255,  blue: 160/255, alpha: 1.0)
        case .Red:
            return UIColor.init(colorLiteralRed: 230/255, green: 43/255,  blue: 87/255,  alpha: 1.0)
        case .Clear:
            return UIColor.clear
        }
    }
    
    //MARK : Scroll View and View Controllers
    open var NavigationScrollView = UIScrollView()
    open var LeftVC : UIViewController?
    open var RightVC : UIViewController?
    open var BottomVC :UIViewController?
    open var TopVC : UIViewController?
    fileprivate var LocalVCs : [UIViewController]!
    fileprivate var CurrentVCs: [UIViewController]!
    fileprivate var ScrollViewController = UIViewController()
    
    //MARK: Variables
    open weak var datasource: SCNavigationDataSource?
    fileprivate var isMovingUp     = false
    fileprivate var isMovingAcross = false
    
    //MARK : Initializers
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    open func setupView() {
        
    }
    
    override open func loadView() {
        super.loadView()
        
        self.view.frame = CGRect(x: 0, y: 0, width: constants.ScreenWidth, height: constants.ScreenHeight)
        
        LocalVCs = datasource?.ViewControllers()
        
        guard self.LocalVCs != nil else {
            print("Please Add View Controllers")
            return
        }
        self.SetUpScrollView()
        self.SetUpViewControllers()
    }
    
    //MARK : Set Up View Controllers
    fileprivate func SetUpViewControllers()
    {
        CurrentVCs = [UIViewController]()
        
        for VC in self.LocalVCs
        {
            CurrentVCs.append(VC)
        }
        
        //Left View Controller
        self.LeftVC = (self.CurrentVCs[0])
        
        self.LeftVC?.view.frame = CGRect(x: 0 ,y: constants.ScreenHeight * 1.1, width: constants.ScreenWidth, height: constants.ScreenHeight * 0.9)
        
        self.LeftVC?.view.layer.mask = self.CornerMaskLayer()
        
        self.LeftVC?.view.backgroundColor = UIColor.white
        
        self.NavigationScrollView.addSubview((self.LeftVC?.view)!)
        
        //Right View Controller
        self.RightVC = (self.CurrentVCs[1])
        
        self.RightVC?.view.frame = CGRect(x: constants.ScreenWidth * 2, y: constants.ScreenHeight * 1.1, width: constants.ScreenWidth, height: constants.ScreenHeight * 0.9)
        
        self.RightVC?.view.layer.mask = self.CornerMaskLayer()
        
        self.RightVC?.view.backgroundColor = UIColor.white
        
        self.NavigationScrollView.addSubview((self.RightVC?.view)!)
        
        //Bottom View Controller
        self.BottomVC = (self.CurrentVCs[2])
        
        self.BottomVC?.view.frame = CGRect(x: constants.ScreenWidth, y: constants.ScreenHeight * 2.1 , width: constants.ScreenWidth, height: constants.ScreenHeight * 0.9)
        
        self.BottomVC?.view.layer.mask = self.CornerMaskLayer()
        
        self.BottomVC?.view.backgroundColor = UIColor.white
        
        self.NavigationScrollView.addSubview((self.BottomVC?.view)!)
        
        //Top View Controller
        self.TopVC = (self.CurrentVCs[3])
        
        self.TopVC?.view.frame = CGRect(x: constants.ScreenWidth, y: 0, width: constants.ScreenWidth, height: constants.ScreenHeight)
        
        self.TopVC?.view.backgroundColor = UIColor.white
        
        self.NavigationScrollView.addSubview((self.TopVC?.view)!)
    }
    
    //MARK : SetUp Scroll View
    fileprivate func SetUpScrollView()
    {
        self.NavigationScrollView.frame                          = CGRect(x: 0, y: 0, width: constants.ScreenWidth, height: constants.ScreenHeight)
        
        self.NavigationScrollView.contentSize.width              = constants.ScreenWidth * 3
        
        self.NavigationScrollView.contentSize.height             = constants.ScreenHeight * 3
        
        self.NavigationScrollView.autoresizingMask               = UIViewAutoresizing.flexibleWidth
        
        self.NavigationScrollView.autoresizingMask               = UIViewAutoresizing.flexibleHeight
        
        self.NavigationScrollView.backgroundColor                = UIColor.blue
        
        self.NavigationScrollView.delegate                       = self
        
        self.NavigationScrollView.bounces                        = false
        
        self.NavigationScrollView.showsVerticalScrollIndicator   = false
        
        self.NavigationScrollView.showsHorizontalScrollIndicator = false
        
        self.NavigationScrollView.contentOffset                  = PageViewPoint(ViewController: .CenterVC)
        
        self.NavigationScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.ScrollViewTouched(Sender:))))
        
        self.view.addSubview(self.NavigationScrollView)
    }
    
    //MARK : Create Corners
    fileprivate func CornerMaskLayer() -> CAShapeLayer{
        let BezierPath = UIBezierPath(roundedRect: constants.ScreenBounds, byRoundingCorners: [.topLeft , .topRight] , cornerRadii: CGSize(width: 10, height: 10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = BezierPath.cgPath
        
        return maskLayer
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK Get Touch event on Scroll View
    @objc fileprivate func ScrollViewTouched(Sender : UITapGestureRecognizer)
    {
        ScreenAdjust()
    }
    
    //MARK : Adjust View  Based on Actuation
    fileprivate func ScreenAdjust()
    {
        if (Float(self.NavigationScrollView.contentOffset.x) < self.PageActuationPoint(ViewController: .LeftVC)) {
            self.MoveTo(with: .LeftVC)
        } else if (Float(self.NavigationScrollView.contentOffset.x) > self.PageActuationPoint(ViewController: .RightVC)) {
            self.MoveTo(with: .RightVC)
        } else if (Float(self.NavigationScrollView.contentOffset.y) < self.PageActuationPoint(ViewController: .TopVC)) {
            self.MoveTo(with: .TopVC)
        } else if (Float(self.NavigationScrollView.contentOffset.y) > self.PageActuationPoint(ViewController: .BottomVC)) {
            self.MoveTo(with: .BottomVC)
        } else {
            self.MoveTo(with: .CenterVC)
        }
    }
    
    //MARK :  Add BackGround Color
    fileprivate func AddScrollViewBackgroundColor()
    {
        if (self.NavigationScrollView.contentOffset.x < constants.ScreenWidth) {
            self.NavigationScrollView.backgroundColor = self.ScrollViewColor(BackColor: .Blue).withAlphaComponent(100 / self.NavigationScrollView.contentOffset.x)
        } else if (self.NavigationScrollView.contentOffset.x > constants.ScreenWidth) {
            self.NavigationScrollView.backgroundColor = self.ScrollViewColor(BackColor: .Purple).withAlphaComponent(1 - ((constants.ScreenWidth * 2 / self.NavigationScrollView.contentOffset.x) - 1))
        } else if (self.NavigationScrollView.contentOffset.y > constants.ScreenHeight) {
            self.NavigationScrollView.backgroundColor = self.ScrollViewColor(BackColor: .Red).withAlphaComponent((1 - ((constants.ScreenHeight * 2 / self.NavigationScrollView.contentOffset.y) - 1)))
        } else {
            self.NavigationScrollView.backgroundColor = self.ScrollViewColor(BackColor: .Clear)
        }
    }
    
    //MARK : Move to View
    fileprivate func MoveTo(with PageNumber: VCPage)
    {
        switch PageNumber {
        case .LeftVC:
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .LeftVC), animated: true)
        case .RightVC:
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .RightVC), animated: true)
        case .BottomVC:
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .BottomVC), animated: true)
        case .TopVC:
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .TopVC), animated: true)
        case .CenterVC:
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .CenterVC), animated: true)
        }
    }
    
    //MARK : Public Func to move view
    public func MoveToPage(with index : Int)
    {
        switch index {
        case 0:
            self.MoveTo(with: .LeftVC)
        case 1:
            self.MoveTo(with: .RightVC)
        case 2:
            self.MoveTo(with: .BottomVC)
        case 3:
            self.MoveTo(with: .TopVC)
        case 4:
            self.MoveTo(with: .CenterVC)
        default:
            self.MoveTo(with: .CenterVC)
        }
    }
}

extension SCNavigatorController : UIScrollViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //MARK : Check Location Bounds
        if (self.NavigationScrollView.contentOffset.y > constants.ScreenHeight || self.NavigationScrollView.contentOffset.y < constants.ScreenHeight) && !isMovingAcross {
            self.NavigationScrollView.contentOffset.x = constants.ScreenWidth
            isMovingUp = true
        } else {
            isMovingUp = false
        }
        
        if (self.NavigationScrollView.contentOffset.x < constants.ScreenWidth || self.NavigationScrollView.contentOffset.x > constants.ScreenWidth) && !isMovingUp {
            isMovingAcross = true
            self.NavigationScrollView.contentOffset.y = constants.ScreenHeight
        } else {
            isMovingAcross = false
        }
        self.AddScrollViewBackgroundColor()
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if ((velocity.x < -1.5) && isMovingAcross) {
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .LeftVC), animated: true)
        } else if ((velocity.x > 1.5) && isMovingAcross) {
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .RightVC), animated: true)
        } else if ((velocity.y < -1.5) && isMovingUp){
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .TopVC), animated: true)
        } else if ((velocity.y > 1.5)  && isMovingUp) {
            self.NavigationScrollView.setContentOffset(self.PageViewPoint(ViewController: .BottomVC), animated: true)
        }
        ScreenAdjust()
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        ScreenAdjust()
    }
}

