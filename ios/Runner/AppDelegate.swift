import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Configuración de notificaciones
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    
    // Configuración de la aplicación
    GeneratedPluginRegistrant.register(with: self)
    
    // Configuración de la barra de estado
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = UIColor(red: 0.247, green: 0.318, blue: 0.710, alpha: 1.0) // Indigo color
      appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      
      UINavigationBar.appearance().standardAppearance = appearance
      UINavigationBar.appearance().scrollEdgeAppearance = appearance
      UINavigationBar.appearance().compactAppearance = appearance
    }
    
    // Configuración de la barra de herramientas
    if #available(iOS 13.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = UIColor.systemBackground
      
      UITabBar.appearance().standardAppearance = appearance
      UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Manejo de notificaciones cuando la app está en primer plano
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }
  
  // Manejo de toques en notificaciones
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    
    // Aquí puedes manejar las acciones de las notificaciones
    if let taskId = userInfo["task_id"] as? String {
      // Navegar a la tarea específica
      print("Notificación tocada para tarea: \(taskId)")
    }
    
    completionHandler()
  }
  
  // Configuración de orientación
  override func application(
    _ application: UIApplication,
    supportedInterfaceOrientationsFor window: UIWindow?
  ) -> UIInterfaceOrientationMask {
    // Solo orientación vertical para iPhone
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .portrait
    }
    // Todas las orientaciones para iPad
    return .all
  }
  
  // Manejo de memoria
  override func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    super.applicationDidReceiveMemoryWarning(application)
    // Limpiar caché si es necesario
  }
  
  // Aplicación entrará en background
  override func applicationDidEnterBackground(_ application: UIApplication) {
    super.applicationDidEnterBackground(application)
    // Guardar datos si es necesario
  }
  
  // Aplicación volverá al primer plano
  override func applicationWillEnterForeground(_ application: UIApplication) {
    super.applicationWillEnterForeground(application)
    // Actualizar datos si es necesario
  }
  
  // Aplicación terminará
  override func applicationWillTerminate(_ application: UIApplication) {
    super.applicationWillTerminate(application)
    // Limpiar recursos si es necesario
  }
} 