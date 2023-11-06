//
//  TimerView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/06.
//

import SwiftUI

struct TimerView: View {
    // 表示内容の変数定義
    @State private var displayTime = ""

    // 現在日時の取得
    @State private var nowDate = Date()

    // 表示形式、タイムゾーンの定義用
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.setTemplate("M/d EEEE H:m:s")
    }
    
    var body: some View {
        Text(displayTime.isEmpty ? "\(dateFormatter.string(from: nowDate))" : displayTime)
            .font(.system(size: 50))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.nowDate = Date()
                    displayTime = "\(dateFormatter.string(from: nowDate))"
                }
            }
    }
}

#Preview {
    TimerView()
}

extension DateFormatter {
    func setTemplate(_ template: String) {
        // optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: .current)
    }
}
