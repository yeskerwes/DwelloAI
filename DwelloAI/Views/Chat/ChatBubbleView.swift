//
//  ChatBubbleView.swift
//  DwelloAI
//
//  Created by Bakdaulet Yeskermes on 09.05.2026.
//

import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 5) {
                Text(message.text)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(message.isFromCurrentUser ? .white : .black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromCurrentUser
                        ? Color("AccentColor")
                        : Color.white
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                Text(message.time)
                    .font(.custom("Poppins-Regular", size: 11))
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 4)
            }

            if !message.isFromCurrentUser {
                Spacer(minLength: 60)
            }
        }
    }
}
