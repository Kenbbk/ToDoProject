//
//  SceneDelegate.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var userDefaultService: PersistentManager = UserDefaultService()
    
    private lazy var toDoRepository = TodoRepository(persistentManager: userDefaultService)
    
    private lazy var itemService = ItemService()
    
    private lazy var sectionService = SectionService()
    
    private lazy var imageNetworkService = ImageNetworkService()
    
    private let nav = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
       
        let mainVC = makeMainVC()
        nav.viewControllers = [mainVC]
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
    }
            
    private func makeMainVC() -> MainVC {
        
        let selection = { [weak self] row in
            
            guard let self else { return }
            
            let vc = row == 0 ? makeToDoVC() : makeDoneVC()
            nav.pushViewController(vc, animated: true)
        }
        
        return MainVC(toDoRepository: toDoRepository, ImageNetworkService: imageNetworkService, selection: selection)
    }
    
    private func makeToDoVC() ->  ToDoVC {
        return ToDoVC(toDoRepository: toDoRepository, persistentManager: userDefaultService)
    }
    
    private func makeDoneVC() -> DoneVC {
        return DoneVC(toDoRepository: toDoRepository)
    }

}

