//
// TimeoutTaskViewModifier.swift
// MakeItSo
//
// Created by Peter Friese on 19.11.2024
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI

struct TimeoutTaskViewModifier: ViewModifier {
  /// The duration after which the task will be executed.
  let timeout: ContinuousClock.Instant.Duration

  /// The action to perform after the timeout duration.
  let action: @Sendable () async -> Void

  func body(content: Content) -> some View {
    content
      .task {
        do {
          try await Task.sleep(for: timeout)
          await action()
        }
        catch {
        }
      }
  }
}

extension View {
  /// Adds an asynchronous task to perform after a specified timeout when the view appears.
  ///
  /// - Parameters:
  ///   - timeout: The duration to wait before executing the task.
  ///   - action: The asynchronous action to perform after the timeout.
  ///
  /// - Returns: A view that adds an asynchronous task with a timeout to the current view.
  func task(timeout: ContinuousClock.Duration, action: @Sendable @escaping () async -> Void) -> some View {
    modifier(TimeoutTaskViewModifier(timeout: timeout, action: action))
  }
}

struct DebounceTaskViewModifier<T>: ViewModifier where T: Equatable {
  /// The value used to identify the task.
  /// When this value changes, the task will be cancelled and a new one will start.
  let value: T

  /// The duration to debounce the task.
  let debounce: ContinuousClock.Instant.Duration

  /// The action to perform after the debounce duration.
  let action: @Sendable () async -> Void

  func body(content: Content) -> some View {
    content
      .task(id: value) {
        do {
          try await Task.sleep(for: debounce)
          await action()
        }
        catch {
        }
      }
  }
}

extension View {
  /// Adds an asynchronous task to perform when the view appears.
  /// The task is debounced, so it will only execute once after the
  /// specified duration, even if the value identifying the task
  /// changes multiple times.
  ///
  /// - Parameters:
  ///   - value: A value used to identify the task. When this value
  ///     changes, the task will be cancelled and a new one will start.
  ///   - debounce: The duration to debounce the task.
  ///   - action: The asynchronous action to perform after the
  ///     debounce duration.
  ///
  /// - Returns: A view that adds an asynchronous task to the current view.
  func task<T>(id value: T, debounce: ContinuousClock.Duration, action: @Sendable @escaping () async -> Void) -> some View where T : Equatable {
    modifier(DebounceTaskViewModifier(value: value, debounce: debounce, action: action))
  }
}

