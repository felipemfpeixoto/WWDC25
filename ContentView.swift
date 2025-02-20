import SwiftUI
import UIKit
import SpriteKit

struct ContentView: View {
    // MARK: Apenar para fins de teste
    @State var router: Router = .onBoarding
    
    var body: some View {
        ZStack {
            switch router {
            case .onBoarding:
                OnBoardingView(router: $router)
                    .transition(.opacity)
            case .menu:
                MenuView(router: $router, menuState: .firstLesson)
                    .transition(.opacity)
            case .lessonOne:
                LessonOneView(router: $router)
                    .transition(.opacity)
            case .menu2:
                MenuView(router: $router, menuState: .secondLesson)
                    .transition(.opacity)
            case .lessonTwo:
                LessonTwoView(router: $router)
            case .menu3:
                MenuView(router: $router, menuState: .thirdLesson)
                    .transition(.opacity)
            case .lessonThree:
                LessonThreeView(router: $router)
                    .transition(.opacity)
            case .completed:
                MenuView(router: $router, menuState: .completed)
                    .transition(.opacity)
            }
        }
        .animation(.default, value: router)
        .ignoresSafeArea()
    }
}
