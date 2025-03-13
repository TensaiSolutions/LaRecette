//
//  Toast.swift
//  LaRecette
//
//  Created by philip sidell on 3/11/25.
//

import SwiftUI

struct Toast: Equatable {
    var color: Color
    var icon: String
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}

enum ToastStyle {
    case error
    case success
    case warning
    case info
}

//extension ToastStyle {
//    var themeColor: Color {
//        switch self {
//        case .error:
//            return .red
//        case .success:
//            return .green
//        case .warning:
//            return .yellow
//        case .info:
//            return .blue
//        }
//    }
//    
//    var icon: String {
//        switch self {
//        case .error:
//            return "exclamationmark.triangle.fill"
//        case .success:
//            return "checkmark.circle.fill"
//        case .warning:
//            return "exclamationmark.triangle.fill"
//        case .info:
//            return "info.circle.fill"
//        }
//    }
//}
extension Toast {
    static func error(_ message: String) -> Toast { Toast(color: .red, icon: "exclamationmark.triangle.fill", message: message) }
    static func success(_ message: String) -> Toast { Toast(color: .green, icon: "checkmark.circle.fill", message: message) }
    static func warning(_ message: String) -> Toast { Toast(color: .green, icon: "exclamationmark.triangle.fill", message: message) }
    static func info(_ message: String) -> Toast { Toast(color: .green, icon: "info.circle.fill", message: message) }
    
}


struct ToastView: View {
    var toast: Toast
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: toast.icon)
                .foregroundColor(toast.color)
            Text(message)
                .font(Font.caption)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Spacer(minLength: 10)
            
            Button{
                onCancelTapped()
                
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(toast.color)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color.teal.opacity(0.5))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .opacity(0.2)
        )
        .padding(.horizontal, 16)
        
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: 200)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) {
                showToast()
            }
    }
    
    @ViewBuilder
    private func mainToastView() -> some View {
        if let toast {
            VStack {
                ToastView(toast: toast, message: toast.message, width: toast.width) {
                    dismissToast()
                }
                Spacer()
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    ToastView(toast: .error("OOPS"), message: "OOPS") {}
}
