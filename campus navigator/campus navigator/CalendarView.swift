import SwiftUI

struct CalendarView: View {
    let bookedDates: [Date]
    
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let components = calendar.dateComponents([.year, .month], from: today)
        let startOfMonth = calendar.date(from: components)!
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            ForEach(range, id: \.self) { day in
                let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
                let isBooked = bookedDates.contains { calendar.isDate($0, inSameDayAs: date) }
                
                Text(dateFormatter.string(from: date))
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(isBooked ? Color.red.opacity(0.8) : Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(isBooked ? .white : .primary)
            }
        }
        .padding()
    }
}

