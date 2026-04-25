import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let contentType: String
    let widgetHeader: String
    let widgetMode: String
    let quoteAuthor: String
    let quoteText: String
    let quoteSource: String
    let quoteExplanation: String
    let quoteCategories: String
    let streak: String
}

struct QuoteProvider: TimelineProvider {
    private let suiteName = "group.com.example.marx_app"

    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(
            date: Date(),
            contentType: "quote",
            widgetHeader: "ZITATATLAS",
            widgetMode: "PUBLIC",
            quoteAuthor: "Zitatatlas",
            quoteText: "Ein Gespenst geht um in Europa...",
            quoteSource: "Kommunistisches Manifest, 1848",
            quoteExplanation: "Taegliches Zitat mit kurzer Erklaerung.",
            quoteCategories: "Klassenkampf, Geschichte",
            streak: "0"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let entry = loadEntry()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }

    private func loadEntry() -> QuoteEntry {
        let defaults = UserDefaults(suiteName: suiteName)
        let contentType = defaults?.string(forKey: "content_type") ?? "quote"
        let widgetHeader = defaults?.string(forKey: "widget_header")
            ?? defaults?.string(forKey: "kicker")
            ?? (contentType == "fact" ? "WELTGESCHICHTE" : "ZITATATLAS")
        let quoteSource = defaults?.string(forKey: "quote_source")
            ?? defaults?.string(forKey: "source")
            ?? "Zitatatlas"
        let quoteExplanation = defaults?.string(forKey: "quote_explanation")
            ?? defaults?.string(forKey: "explanation")
            ?? ""

        return QuoteEntry(
            date: Date(),
            contentType: contentType,
            widgetHeader: widgetHeader,
            widgetMode: defaults?.string(forKey: "widget_mode") ?? "PUBLIC",
            quoteAuthor: defaults?.string(forKey: "quote_author") ?? "Zitatatlas",
            quoteText: defaults?.string(forKey: "quote_text") ?? "Tageszitat wird geladen...",
            quoteSource: quoteSource,
            quoteExplanation: quoteExplanation,
            quoteCategories: defaults?.string(forKey: "quote_categories") ?? "",
            streak: defaults?.string(forKey: "streak") ?? "0"
        )
    }
}

struct QuoteWidgetEntryView: View {
    var entry: QuoteProvider.Entry
    @Environment(\.widgetFamily) private var family

    private var headerPadH: CGFloat {
        switch family {
        case .systemSmall: return 10
        case .systemLarge: return 16
        default: return 12
        }
    }

    private var headerPadV: CGFloat {
        switch family {
        case .systemSmall: return 3
        case .systemLarge: return 5
        default: return 4
        }
    }

    private var contentPad: CGFloat {
        switch family {
        case .systemSmall: return 10
        case .systemLarge: return 16
        default: return 12
        }
    }

    private var quoteFont: CGFloat {
        switch family {
        case .systemSmall: return 12
        case .systemLarge: return 16
        default: return 14
        }
    }

    private var quoteLineLimit: Int {
        switch family {
        case .systemSmall: return 2
        case .systemLarge: return 5
        default: return 3
        }
    }

    private var explanationLineLimit: Int {
        switch family {
        case .systemLarge: return 3
        default: return 2
        }
    }

    private var showExplanation: Bool {
        family != .systemSmall
    }

    private var showLargeOnlyMeta: Bool {
        family == .systemLarge
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.93, green: 0.91, blue: 0.87)

            VStack(spacing: 0) {
                HStack {
                    Text(entry.widgetHeader)
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .kerning(1.1)
                        .foregroundColor(.white)
                    Spacer()
                    Text(entry.widgetMode.uppercased())
                        .font(.system(size: 8, weight: .bold, design: .default))
                        .kerning(0.8)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 1.0, green: 0.10, blue: 0.10))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, headerPadH)
                .padding(.vertical, headerPadV)
                .background(Color(red: 0.77, green: 0.12, blue: 0.12))

                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.quoteText)
                        .font(.system(size: quoteFont, weight: .regular, design: .serif))
                        .italic(entry.contentType == "quote")
                        .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.10))
                        .lineLimit(quoteLineLimit)

                    Rectangle()
                        .fill(Color(red: 0.77, green: 0.12, blue: 0.12))
                        .frame(width: 24, height: 2)

                    if showExplanation {
                        Text(entry.quoteExplanation)
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))
                            .lineLimit(explanationLineLimit)
                            .opacity(entry.quoteExplanation.isEmpty ? 0 : 1)
                    }

                    Spacer(minLength: 0)

                    Text(entry.quoteAuthor.uppercased())
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .kerning(0.8)
                        .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.10))
                        .lineLimit(1)

                    Text(entry.quoteSource.uppercased())
                        .font(.system(size: 10, weight: .regular, design: .default))
                        .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))
                        .lineLimit(1)

                    if showLargeOnlyMeta {
                        Text(entry.quoteCategories.uppercased())
                            .font(.system(size: 10, weight: .regular, design: .default))
                            .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))
                            .lineLimit(1)
                        Text("LEKTUERE · TAG \(entry.streak)")
                            .font(.system(size: 10, weight: .bold, design: .default))
                            .kerning(0.8)
                            .foregroundColor(Color(red: 0.77, green: 0.12, blue: 0.12))
                    }
                }
                .padding(contentPad)
            }
        }
    }
}

struct QuoteWidget: Widget {
    let kind: String = "QuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            QuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Zitatatlas")
        .description("Zeigt das taegliche Zitat mit Kontext und kurzer Einordnung.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
