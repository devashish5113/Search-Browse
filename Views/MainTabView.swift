import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1  // Start on search tab
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Image(systemName: "rectangle.3.group")
                        Text("Dashboard")
                    }
                    .tag(0)
                
                SearchBrowseView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                WishlistView()
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Wishlist")
                    }
                    .tag(2)
            }
            .accentColor(.blue)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Preview provider for testing
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} 