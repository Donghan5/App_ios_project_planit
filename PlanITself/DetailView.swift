import SwiftUI

struct DetailView: View {
    var item: MyItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let title = item.title {
                Text(title)
                    .font(.largeTitle) // 제목을 크게
                    .padding(.bottom, 4)
            }
            
            if let timestamp = item.timestamp {
                Text("날짜: \(timestamp, formatter: itemFormatter)")
                    .font(.subheadline) // 날짜와 시간을 작게
                    .foregroundColor(.gray) // 회색으로 표시
            }
            
            if let description = item.descriptionText {
                Text(description)
                    .font(.body) // 설명을 기본 크기로
            }
        }
        .padding()
        .navigationTitle("상세 보기")
        .navigationBarTitleDisplayMode(.inline) // 네비게이션 바에 타이틀 디스플레이 모드
    }
}

// 날짜 포맷터 정의
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

