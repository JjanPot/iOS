//
//  RangeCalendarView 2.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//


import SwiftUI

// MARK: - RangeCalendarView
/// 날짜 범위 선택 달력 컴포넌트
/// - startDate: 선택된 시작일 (Binding)
/// - endDate: 시작일 + rangeDays - 1 로 자동 계산된 종료일 (Binding)
/// - rangeDays: 선택 기간 일수 (기본 7일)
struct RangeCalendarView: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    var rangeDays: Int = 7

    @State private var displayedMonth: Date = Date()

    private let calendar = Calendar.current
    private let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            // MARK: Header
            HStack(alignment: .center) {
                // 2026년 3월
                Text(headerTitle)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(.black900)
                    

                Spacer()

                // <,> 버튼
                HStack(spacing: .zero) {
                    Button(action: movePreviousMonth) {
                        Image(systemName: "chevron.left")
                            .frame(width: 16, height: 16)
                            .foregroundColor(.black200)
                    }
                    

                    Button(action: moveNextMonth) {
                        Image(systemName: "chevron.right")
                            .frame(width: 16, height: 16)
                            .foregroundColor(.black200)
                    }
                    
                }
            }
            .frame(height: 24)
            .padding(.bottom, 10)

            // MARK: Weekday Labels
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.pretendard(.regular, size: 10))
                        .foregroundColor(.black900)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30, alignment: .center)
                }
            }

            // MARK: Day Grid
            let days = makeDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, date in
                    DayCell(
                        date: date,
                        isCurrentMonth: date.map { isCurrentMonth($0) } ?? false,
                        isStart: isStart(date),
                        isEnd: isEnd(date),
                        isInRange: isInRange(date),
                        isRangeStart: isRangeEdge(index: index, date: date, checkingStart: true),
                        isRangeEnd: isRangeEdge(index: index, date: date, checkingStart: false),
                        isPastDate: isPastDate(date),
                        onTap: { selectDate(date) }
                    )
                }
            }

        }
        .padding(.top, 18)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .background(Color(.white))
        .rounded(radius: 12)
        .roundedBorder(color: .black100, radius: 12)
        
        
        
        
        
    }

    // MARK: - Computed

    private var headerTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: displayedMonth)
    }

    // MARK: - Date Logic

    private func makeDays() -> [Date?] {
        guard let monthStart = calendar.date(
            from: calendar.dateComponents([.year, .month], from: displayedMonth)
        ) else { return [] }

        let weekdayOfFirst = (calendar.component(.weekday, from: monthStart) - 1 + 7) % 7
        let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 30

        var days: [Date?] = []

        // 이전달 빈칸
        if weekdayOfFirst > 0 {
            guard let prevMonthEnd = calendar.date(byAdding: .day, value: -1, to: monthStart) else { return [] }
             let prevDaysInMonth = calendar.component(.day, from: prevMonthEnd)
            for i in stride(from: weekdayOfFirst - 1, through: 0, by: -1) {
                days.append(calendar.date(byAdding: .day, value: -i - 1, to: monthStart))
            }
        }

        // 이번달
        for i in 0..<daysInMonth {
            days.append(calendar.date(byAdding: .day, value: i, to: monthStart))
        }

        // 다음달 빈칸 (6주 고정 - 항상 42개 셀)
        let totalCells = 42 // 6주 * 7일
        if let lastDay = days.last ?? nil {
            let remainingCells = totalCells - days.count
            for i in 1...remainingCells {
                days.append(calendar.date(byAdding: .day, value: i, to: lastDay))
            }
        }

        return days
    }

    private func isCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
    }

    private func isStart(_ date: Date?) -> Bool {
        guard let date, let start = startDate else { return false }
        return calendar.isDate(date, inSameDayAs: start)
    }

    private func isEnd(_ date: Date?) -> Bool {
        guard let date, let end = endDate else { return false }
        return calendar.isDate(date, inSameDayAs: end)
    }

    private func isInRange(_ date: Date?) -> Bool {
        guard let date, let start = startDate, let end = endDate else { return false }
        return date >= start && date <= end
    }

    /// 범위의 행 시작/끝 여부 (배경 라운딩 처리용)
    private func isRangeEdge(index: Int, date: Date?, checkingStart: Bool) -> Bool {
        guard let date else { return false }
        if checkingStart {
            return isStart(date) || index % 7 == 0
        } else {
            return isEnd(date) || index % 7 == 6
        }
    }

    /// 오늘 이전 날짜인지 확인 (오늘 포함 X)
    private func isPastDate(_ date: Date?) -> Bool {
        guard let date else { return false }
        let today = calendar.startOfDay(for: Date())
        let compareDate = calendar.startOfDay(for: date)
        return compareDate < today
    }

    private func selectDate(_ date: Date?) {
        guard let date, isCurrentMonth(date) else { return }

        // 과거 날짜는 선택 불가
        if isPastDate(date) { return }

        startDate = calendar.startOfDay(for: date)
        if let start = startDate,
           let end = calendar.date(byAdding: .day, value: rangeDays - 1, to: start) {
            endDate = end
        }
    }

    private func movePreviousMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
    }

    private func moveNextMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
    }
}

// MARK: - DayCell
private struct DayCell: View {
    let date: Date?
    let isCurrentMonth: Bool
    let isStart: Bool
    let isEnd: Bool
    let isInRange: Bool
    let isRangeStart: Bool
    let isRangeEnd: Bool
    let isPastDate: Bool
    let onTap: () -> Void

    private let accentColor = Color(red: 1.0, green: 0.55, blue: 0.2) // 오렌지

    var body: some View {
        ZStack {
            // 범위 배경 (행 연결)
            if isInRange && !isPastDate {
                HStack(spacing: .zero) {
                    // 왼쪽 절반
                    Rectangle()
                        .fill(isRangeStart ? Color.clear : rangeBackground)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // 오른쪽 절반
                    Rectangle()
                        .fill(isRangeEnd ? Color.clear : rangeBackground)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .overlay(alignment: .center) {
                    if isRangeStart || isRangeEnd {
                        Circle()
                            .fill(rangeBackground)
                    }
                }
            }

            // 날짜 원
            Circle()
                .fill((isStart || isEnd) && !isPastDate ? accentColor : Color.clear)
                .frame(width: 30, height: 30)

            if let date {
                Text(dayString(from: date))
                    .font(.pretendard((isStart || isEnd ? .semiBold : .regular), size: 10))
                    .foregroundColor(textColor)
            }
        }
        .frame(height: 30)
        .contentShape(Rectangle())
        .onTapGesture {
            if date != nil && !isPastDate { onTap() }
        }
    }

    private var rangeBackground: Color {
        Color.orange100
    }

    private var textColor: Color {
        if isPastDate { return Color.black200 } // 과거 날짜는 흐리게
        if isStart || isEnd { return .white }
        if !isCurrentMonth { return Color(.black300) }
        return Color.black900
    }

    private func dayString(from date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        return String(format: "%02d", day)
    }
}

// MARK: - Preview
struct RangeCalendarView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var startDate: Date? = Calendar.current.date(
            from: DateComponents(year: 2026, month: 7, day: 13)
        )
        @State var endDate: Date? = Calendar.current.date(
            from: DateComponents(year: 2026, month: 7, day: 19)
        )

        var body: some View {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                    RangeCalendarView(
                        startDate: $startDate,
                        endDate: $endDate,
                        rangeDays: 7
                    )
                    .padding(.horizontal, 20)

                
            }
        }

        private func formatted(_ date: Date) -> String {
            let f = DateFormatter()
            f.dateFormat = "M/d"
            return f.string(from: date)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
