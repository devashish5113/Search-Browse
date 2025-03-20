import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Back button
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding()
                
                // Book cover image
                Image(systemName: "book.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(book.title)
                        .font(.title)
                        .bold()
                    
                    Text("By \(book.author)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("Published in \(book.publicationYear)")
                        .font(.body)
                    
                    HStack {
                        Text("Status:")
                        Text(book.availability.rawValue.capitalized)
                            .foregroundColor(book.availability == .available ? .green : .red)
                            .bold()
                    }
                    
                    Button(action: {
                        // Reserve functionality will be implemented later
                    }) {
                        Text("Reserve Book")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(book.availability == .available ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(book.availability != .available)
                }
                .padding()
            }
        }
    }
}