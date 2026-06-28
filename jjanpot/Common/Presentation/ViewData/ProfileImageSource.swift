import SwiftUI
import UIKit

enum ProfileImageSource {
    case local(UIImage, Data)
    case network(String)
}
