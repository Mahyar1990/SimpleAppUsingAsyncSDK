//
//  ViewController.swift
//  SimpleAppUsingAsync
//
//  Created by Mahyar Zhiani on 5/15/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import UIKit
import FanapPodAsyncSDK
import SwiftyJSON

class MyViewController: UIViewController {
    
    let cellId = "cellId"
    var logArr = [String]()
    var logHeightArr = [Int]()
    var logBackgroundColor = [UIColor]()
//    let cellColors = [UIColor.red, UIColor.green, UIColor.blue]
    
    var myAsyncObject: Async?
    
    let socketAddress = "ws://172.16.106.26:8003/ws"
    let serverName = "chat-server"
    let token = "6421ecebd40b4d09923bcf6379663d87"
    
    let connectToSocketButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.setTitle("Click to Connect to socket...", for: UIControlState.normal)
        mb.backgroundColor = UIColor(red: 0, green: 150/255, blue: 200/255, alpha: 1.0)
        mb.layer.cornerRadius = 5
        mb.layer.borderWidth = 2
        mb.layer.borderColor = UIColor.clear.cgColor
        mb.layer.shadowColor = UIColor(red: 0, green: 100/255, blue: 110/255, alpha: 1.0).cgColor
        mb.layer.shadowOpacity = 2
        mb.layer.shadowRadius = 1
        mb.layer.shadowOffset = CGSize(width: 0, height: 3)
        mb.addTarget(self, action: #selector(connectToSocketButtonPressed), for: UIControlEvents.touchUpInside)
        return mb
    }()
    
    let sendPingButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.setTitle("Click to send Ping...", for: UIControlState.normal)
        mb.backgroundColor = UIColor(red: 0, green: 150/255, blue: 200/255, alpha: 1.0)
        mb.layer.cornerRadius = 5
        mb.layer.borderWidth = 2
        mb.layer.borderColor = UIColor.clear.cgColor
        mb.layer.shadowColor = UIColor(red: 0, green: 100/255, blue: 110/255, alpha: 1.0).cgColor
        mb.layer.shadowOpacity = 2
        mb.layer.shadowRadius = 1
        mb.layer.shadowOffset = CGSize(width: 0, height: 3)
        mb.addTarget(self, action: #selector(sendPingButtonPressed), for: UIControlEvents.touchUpInside)
        return mb
    }()
    
    let inputTextFieldToSendMessage: UITextField = {
        let mt = UITextField()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.placeholder = "type your message..."
        mt.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return mt
    }()
    
    let sendMessageToSocketButton: UIButton = {
        let mb = UIButton()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.setTitle("Click to send message thought socket...", for: UIControlState.normal)
        mb.backgroundColor = UIColor(red: 100/255, green: 150/255, blue: 200/255, alpha: 1.0)
        mb.layer.cornerRadius = 5
        mb.layer.borderWidth = 2
        mb.layer.borderColor = UIColor.clear.cgColor
        mb.layer.shadowColor = UIColor(red: 50/255, green: 100/255, blue: 110/255, alpha: 1.0).cgColor
        mb.layer.shadowOpacity = 2
        mb.layer.shadowRadius = 1
        mb.layer.shadowOffset = CGSize(width: 0, height: 3)
        mb.addTarget(self, action: #selector(sendMessageToSocketPressed), for: UIControlEvents.touchUpInside)
        return mb
    }()
    
    let logView: UIView = {
        let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = UIColor.lightText
        mv.layer.cornerRadius = 5
        mv.layer.borderWidth = 2
        mv.layer.borderColor = UIColor.clear.cgColor
        mv.layer.shadowColor = UIColor.darkGray.cgColor
        mv.layer.shadowOpacity = 2
        mv.layer.shadowRadius = 1
        return mv
    }()
    
    let myLogCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let mcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mcv.translatesAutoresizingMaskIntoConstraints = false
        mcv.backgroundColor = UIColor.clear
        return mcv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        navigationItem.title = "Test Async"
        
        myLogCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        myLogCollectionView.delegate = self
        myLogCollectionView.dataSource = self
        
        setupView()
        
        myAsyncObject = Async(socketAddress: socketAddress, serverName: serverName, deviceId: token, appId: nil, peerId: nil, messageTtl: nil, connectionRetryInterval: nil, reconnectOnClose: true)
        myAsyncObject!.delegate = self
        
    }
    
    func setupView() {
        view.addSubview(connectToSocketButton)
        view.addSubview(sendPingButton)
        view.addSubview(inputTextFieldToSendMessage)
        view.addSubview(sendMessageToSocketButton)
        view.addSubview(logView)
        logView.addSubview(myLogCollectionView)
        
        connectToSocketButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        connectToSocketButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        connectToSocketButton.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        connectToSocketButton.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        connectToSocketButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        sendPingButton.topAnchor.constraint(equalTo: connectToSocketButton.bottomAnchor, constant: 8).isActive = true
        sendPingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        sendPingButton.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        sendPingButton.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        sendPingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        inputTextFieldToSendMessage.topAnchor.constraint(equalTo: sendPingButton.bottomAnchor, constant: 16).isActive = true
        inputTextFieldToSendMessage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        inputTextFieldToSendMessage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        inputTextFieldToSendMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        sendMessageToSocketButton.topAnchor.constraint(equalTo: inputTextFieldToSendMessage.bottomAnchor, constant: 8).isActive = true
        sendMessageToSocketButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        sendMessageToSocketButton.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        sendMessageToSocketButton.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        sendMessageToSocketButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        logView.topAnchor.constraint(equalTo: sendMessageToSocketButton.bottomAnchor, constant: 16).isActive = true
        logView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        logView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        logView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        myLogCollectionView.topAnchor.constraint(equalTo: logView.topAnchor, constant: 8).isActive = true
        myLogCollectionView.leftAnchor.constraint(equalTo: logView.leftAnchor, constant: 8).isActive = true
        myLogCollectionView.rightAnchor.constraint(equalTo: logView.rightAnchor, constant: -8).isActive = true
        myLogCollectionView.bottomAnchor.constraint(equalTo: logView.bottomAnchor, constant: -8).isActive = true
    }
    
    
    
    @objc func connectToSocketButtonPressed() {
        myAsyncObject!.createSocket()
    }
    
    @objc func sendPingButtonPressed() {
        myAsyncObject?.asyncSendPing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.xxx(_:)), name: NSNotification.Name("hhh"), object: nil)
    }
    
    @objc func xxx(_ notification: Notification/*,completion: @escaping (String) -> Void*/) {
        print("\n\n")
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        let key1 = notification.userInfo?["key1"]
        let key2 = notification.userInfo?["key2"]
        print("key1 = \(key1 ?? 0) ------ key2 = \(key2 ?? ":(")")
        print("\n\n")
//        completion("I am returner!!!")
    }
    
    @objc func sendMessageToSocketPressed() {
        
        myAsyncObject?.asyncSend(type: 4, content: "\(inputTextFieldToSendMessage.text ?? "Hello!")", receivers: [126833], priority: 10, ttl: 5)
//        myAsyncObject?.pushSendData(type: 5, content: "receivers: ['126833'], content: \(inputTextFieldToSendMessage.text ?? "Hello!")")
    }
    
    
    
    
}


extension MyViewController: AsyncDelegates {
    func asyncSendMessage(params: Any) {
        print("Delegate: Message Send! \n \(params) \n \n")
        let text = "this Message sends throut socket! \(params)"
        addtext(text: text)
        logHeightArr.append(110)
        logBackgroundColor.append(UIColor.cyan)
    }
    
    func asyncConnect(newPeerID: Int) {
        print("Delegate: Connected! \n \n")
        let text = "Socket is Connected! :)"
        addtext(text: text)
        logHeightArr.append(40)
        logBackgroundColor.append(UIColor.green)
    }
    
    func asyncDisconnect() {
        print("Delegate: Disconnected! \n \n")
        let text = "Socket is Disconnected! :)"
        addtext(text: text)
        logHeightArr.append(40)
        logBackgroundColor.append(UIColor(red: 230/255, green: 50/255, blue: 10/255, alpha: 1))
    }
    
    func asyncReconnect(newPeerID: Int) {
        print("Delegate: Reconnected! \n \n")
        let text = "Socekt is Disconnected! So try to Reconnect:)"
        addtext(text: text)
        logHeightArr.append(40)
        logBackgroundColor.append(UIColor.orange)
    }
    
    func asyncReceiveMessage(params: JSON) {
        print("Delegate: Message Received: \n \(params) \n \n \n")
        let text = "Message Received from Socket: \n \(params)"
        addtext(text: text)
        logHeightArr.append(180)
        logBackgroundColor.append(UIColor.purple.withAlphaComponent(0.5))
        let data: [String : Any] = ["key1": 1, "key2": "value2"]
        NotificationCenter.default.post(name: NSNotification.Name("hhh"), object: nil, userInfo: data)
    }
    
    func asyncStateChanged(socketState: Int, timeUntilReconnect: Int, deviceRegister: Bool, serverRegister: Bool, peerId: Int) {
        print("Delegate: State Changed: \n socketState: \(socketState) \n timeUntilReconnect: \(timeUntilReconnect) \n deviceRegister: \(deviceRegister) \n serverRegister: \(serverRegister) \n peerId: \(peerId) \n \n")
        let text = "Socket State Changed: \n socketState: \(socketState) \n timeUntilReconnect: \(timeUntilReconnect) \n deviceRegister: \(deviceRegister) \n serverRegister: \(serverRegister) \n peerId: \(peerId)"
        addtext(text: text)
        logHeightArr.append(110)
        logBackgroundColor.append(UIColor(white: 0.7, alpha: 1))
    }
    
    func asyncError(errorCode: Int, errorMessage: String, errorEvent: Any?) {
        print("Delegate: Error: \n errorCode: \(errorCode) \n errorMessage: \(errorMessage) \n \n")
        let text = "Error: \n errorCode: \(errorCode) \n errorMessage: \(errorMessage)"
        addtext(text: text)
        logHeightArr.append(120)
        logBackgroundColor.append(UIColor.red)
    }
    
    
    
    
    
    
    func asyncReady() {
        print("Delegate: Async Ready \n \n")
        let text = "Async Ready"
        addtext(text: text)
        logHeightArr.append(40)
        logBackgroundColor.append(UIColor.green)
    }
    
    
    func addtext(text: String) {
        logArr.append(text)
        myLogCollectionView.reloadData()
    }
    
}





extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyCollectionViewCell
        cell.backgroundColor = logBackgroundColor[indexPath.item]
        cell.myTextView.text = logArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cgfloatHeight: CGFloat = CGFloat(logHeightArr[indexPath.item])
        return CGSize(width: view.frame.width - 32, height: cgfloatHeight)
    }
    
}




class MyCollectionViewCell: UICollectionViewCell {
    
    let myTextView: UITextView = {
        let mtv = UITextView()
        mtv.translatesAutoresizingMaskIntoConstraints = false
        mtv.backgroundColor = UIColor.clear
        return mtv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        addSubview(myTextView)
        myTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        myTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        myTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        myTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




























