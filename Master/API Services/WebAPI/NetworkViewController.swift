//
//  NetworkViewController.swift
//  Nerkh
//
//  Created by Sina khanjani on 1/9/1399 AP.
//  Copyright © 1399 Sina Khanjani. All rights reserved.
//

import UIKit

class NetworkViewController: UIViewController {
    
    open var shouldReloadDataWhenNecessary: Bool {
        return true
    }
    open var showLoadingWhenReloading: Bool {
        return true
    }
    
    open var showLoadingWhenFetching: Bool {
        return true
    }
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .white)
        indicatorView.center = view.center
        view.addSubview(indicatorView)
        return indicatorView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(requestForReloading: false)
        if shouldReloadDataWhenNecessary {
            addFetchingObserver()
        }
    }
    
    func addFetchingObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(tryForData), name: Notification.Name("tryForData"), object: nil)
    }
    
    @objc private func tryForData() {
        if shouldReloadDataWhenNecessary {
            if showLoadingWhenReloading && showLoadingWhenFetching { showLoading() }
            reloadData()
        }
    }
    
    func handleRequestByUI<T>(_ network: Network<T,Empty>,success: @escaping (T) -> Void,error: ((Error)->Void)? = nil) {
        network.attack { [weak self] (result) in
            result.ifSuccess { response in
                if self?.showLoadingWhenFetching == true || self?.showLoadingWhenReloading == true {
                    self?.dismissLoading()
                }
                success(response)
            }
            result.ifFailed { (resError) in
                if self?.showLoadingWhenFetching == true  || self?.showLoadingWhenReloading == true {
                    self?.dismissLoading()
                }
                self?.handleConnectionErrors(error: resError)
                error?(resError)
            }
        }.disposed(by: disposeBag)
    }
    
    func fetchData(requestForReloading reloading: Bool) {
        if showLoadingWhenFetching && (!reloading) { showLoading() }
    }
    
    func reloadData() {
        fetchData(requestForReloading: true)
    }
    
    internal func showLoading() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    internal func dismissLoading() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    internal func handleConnectionErrors(error: Error) {
        switch error {
        case NetworkErrors.NotFound:
            break;
        case NetworkErrors.Unathorized:
            break;
        case NetworkErrors.InternalError:
            break;
        case NetworkErrors.BadURL:
            break;
        case NetworkErrors.BadRequest:
            break;
        case NetworkErrors.TimeOuted:
            //you should call 'NotificationCenter.default.post(name: .tryForData, object: nil)' to refresh all view controllers
            break
        case NetworkErrors.json:
            break
        default:
            break
        }
    }
}
