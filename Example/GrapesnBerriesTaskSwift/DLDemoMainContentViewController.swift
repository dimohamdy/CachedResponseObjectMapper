//
//  DLDemoMainContentViewController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import DLHamburguerMenu
import Alamofire
import AlamofireObjectMapper
import CHTCollectionViewWaterfallLayout
import Kingfisher
import ZFDragableModalTransition
import ReachabilitySwift
import JLToast
import CachedResponseObjectMapper
class DLDemoMainContentViewController:  UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout{
    var products:[Product] = [Product]()
    var animator:ZFModalTransitionAnimator!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        let manager:Manager =  self.getpreparedManagerForCache()
        
        // Change individual layout attributes for the spacing between cells
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        
        // Add the waterfall layout to your collection view
        self.collectionView!.collectionViewLayout = layout
        
        
        // Collection view attributes
        self.collectionView!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView!.alwaysBounceVertical = true
        
        
        
        
        // change indicator view style to white
        self.collectionView!.infiniteScrollIndicatorStyle = .White
        
        // Add infinite scroll handler
        self.collectionView!.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let collectionView = scrollView as! UICollectionView
            if reachability.isReachable(){
                
                // suppose this is an array with new data
                let URL = "http://grapesnberries.getsandbox.com/products?count=10&from=\(self!.products.count)"
                manager.request(.GET, URL).responseArray { (response: Response<[Product], NSError>) in
                    
                    let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: (response.data! as NSData), userInfo: nil, storagePolicy: .Allowed)
                    NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
                    
                    
                    let newProducts = response.result.value!
                    
                    
                    var indexPaths = [NSIndexPath]()
                    var index:Int = self!.products.count
                    
                    // create index paths for affected items
                    for story in newProducts {
                        let indexPath = NSIndexPath(forItem: index++, inSection: 0)
                        
                        indexPaths.append(indexPath)
                        self?.products.append(story)
                    }
                    
                    // Update collection view
                    collectionView.performBatchUpdates({ () -> Void in
                        // add new items into collection
                        collectionView.insertItemsAtIndexPaths(indexPaths)
                        }, completion: { (finished) -> Void in
                            // finish infinite scroll animations
                            collectionView.finishInfiniteScroll()
                    });
                    
                }
            }else{
                
            }
            
        }
        
        if reachability.isReachable(){
            
            let cachePolicy: NSURLRequestCachePolicy = .ReloadIgnoringLocalCacheData
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://grapesnberries.getsandbox.com/products?count=10&from=1")!, cachePolicy: cachePolicy, timeoutInterval: 60)
            request.addValue("private", forHTTPHeaderField: "Cache-Control")
            
            manager.request(request).responseArray { (response: Response<[Product], NSError>) in
                
                let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: (response.data! as NSData), userInfo: nil, storagePolicy: .Allowed)
                NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
                
                
                self.products = response.result.value!
                // Attach datasource and delegate
                self.collectionView!.dataSource  = self
                self.collectionView!.delegate = self
                
                self.collectionView!.reloadData()
            }
            
        }else{
            
            let cachePolicy: NSURLRequestCachePolicy = .ReturnCacheDataElseLoad
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://grapesnberries.getsandbox.com/products?count=10&from=1")!, cachePolicy: cachePolicy, timeoutInterval: 60)
            request.addValue("private", forHTTPHeaderField: "Cache-Control")
            
            let response: [Product] =   NSURLCache.sharedURLCache().cachedResponseForRequest(request)!.ObjectMapperArraySerializer()
            
            self.products = response
            // Attach datasource and delegate
            self.collectionView!.dataSource  = self
            self.collectionView!.delegate = self
            
            self.collectionView!.reloadData()
            
            
        }
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
                
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
                JLToast.makeText("No Internet Connection", duration: JLToastDelay.LongDelay)
                
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func getpreparedManagerForCache() -> Manager{
        // Create a shared URL cache
        let memoryCapacity = 500 * 1024 * 1024; // 500 MB
        let diskCapacity = 500 * 1024 * 1024; // 500 MB
        let cache = NSURLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        
        // Create a custom configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders
        configuration.HTTPAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .UseProtocolCachePolicy // this is the default
        configuration.URLCache = cache
        
        // Create your own manager instance that uses your custom configuration
        let manager = Alamofire.Manager(configuration: configuration)
        
        return manager
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - CollectionView Delegate Methods
    
    //** Number of Cells in the CollectionView */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    
    //** Create a basic CollectionView Cell */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Create the cell and return the cell
        let cell:ProductCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCollectionViewCell", forIndexPath: indexPath) as! ProductCollectionViewCell
        let product:Product = products[indexPath.row]
        cell.productImageView.kf_setImageWithURL(NSURL(string: (product.image?.url)!)!)
        cell.productPriceLable.text = "\(product.price)"
        cell.productDescriptionLabel.text = product.productDescription
        
        
        return cell
    }
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        let product:Product = products[indexPath.row]
        // create a cell size from the image size, and return the size
        let imageSize = CGSizeMake(CGFloat((product.image?.width)!) ,CGFloat((product.image?.height)!))
        
        return imageSize
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalVC:ProductDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ProductDetailViewController") as! ProductDetailViewController
        let product:Product = products[indexPath.row]
        
        modalVC.product = product
        
        //        modalVC.isShowingScrollView = self.scrollViewSwitch.isOn;
        modalVC.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        self.animator = ZFModalTransitionAnimator(modalViewController: modalVC)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.5
        self.animator.behindViewScale = 0.5
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Bottom
        modalVC.transitioningDelegate = self.animator;
        //        [self presentViewController:modalVC animated:YES completion:nil];
        
        self.presentViewController(modalVC, animated: true,completion: nil)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    
    
    @IBAction func menuButtonTouched(sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
}
