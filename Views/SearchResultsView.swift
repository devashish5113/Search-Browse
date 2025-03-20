import SwiftUI

struct SearchResultsView: View {
    let searchResults: [Book]
    @Binding var selectedBook: Book?
    @Binding var showBookDetail: Bool
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 16)
            ], spacing: 16) {
                ForEach(searchResults) { book in
                    BookCardView(
                        book: book,
                        onTap: {
                            selectedBook = book
                            showBookDetail = true
                        }
                    )
                }
            }
            .padding()
        }
    }
}