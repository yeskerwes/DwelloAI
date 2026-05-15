//
//  SplashView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 14.05.2026.
//

import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void

    @State private var logoScale: CGFloat = 0.92
    @State private var logoOpacity: Double = 0
    @State private var coloredLogoProgress: CGFloat = 0
    @State private var screenOpacity: Double = 1

    private let logoSize: CGFloat = 250
    private let softEdgeWidth: CGFloat = 70

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("AccentColor"),
                    Color("lightGreen")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ZStack {
                Image("dwello-logo-white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize, height: logoSize)

                Image("dwello-logo-colored")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize, height: logoSize)
                    .mask(
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(.white)
                                .frame(
                                    width: max(
                                        0,
                                        logoSize * coloredLogoProgress - softEdgeWidth
                                    )
                                )

                            LinearGradient(
                                colors: [
                                    .white,
                                    .white.opacity(0.85),
                                    .white.opacity(0.35),
                                    .white.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(
                                width: coloredLogoProgress > 0 ? softEdgeWidth : 0
                            )

                            Spacer(minLength: 0)
                        }
                        .frame(
                            width: logoSize,
                            height: logoSize,
                            alignment: .leading
                        )
                    )
            }
            .frame(width: logoSize, height: logoSize)
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
        }
        .opacity(screenOpacity)
        .onAppear {
            runAnimation()
        }
    }

    private func runAnimation() {
        withAnimation(.easeOut(duration: 0.8)) {
            logoOpacity = 1
            logoScale = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 2.0)) {
                coloredLogoProgress = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                screenOpacity = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onFinished()
            }
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
