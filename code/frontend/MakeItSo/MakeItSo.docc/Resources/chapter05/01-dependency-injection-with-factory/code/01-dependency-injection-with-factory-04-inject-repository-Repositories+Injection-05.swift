import Foundation
import Factory

extension Container {
  public var remindersRepository: Factory<RemindersRepository> {
    self {
      RemindersRepository()
    }.singleton
  }
}
