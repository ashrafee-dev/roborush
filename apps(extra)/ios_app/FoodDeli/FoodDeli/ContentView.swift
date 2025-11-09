import SwiftUI
import Combine

@main
struct FoodCortApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

// MARK: - Splash Screen
struct SplashView: View {
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.orange))
                    
                    Text("FOODCORT")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("FOOD DELIVERY SERVICE")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        navigate = true
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.orange))
                    }
                    .padding(.bottom, 60)
                }
                .padding()
                .navigationDestination(isPresented: $navigate) {
                    LoginView()
                }
            }
        }
    }
}

// MARK: - Login View
struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var navigate = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Let's get something")
                .font(.title2)
                .bold()
            
            Text("Good to see you back.")
                .foregroundColor(.gray)
            
            HStack(spacing: 25) {
                Image(systemName: "g.circle.fill").font(.largeTitle).foregroundColor(.red)
                Image(systemName: "f.circle.fill").font(.largeTitle).foregroundColor(.blue)
                Image(systemName: "bird.fill").font(.largeTitle).foregroundColor(.cyan)
            }
            .padding(.bottom)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Toggle("Remember me next time", isOn: .constant(true))
                .padding(.horizontal)
            
            Button("Sign In") {
                navigate = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)
            .padding()
        }
        .padding()
        .navigationTitle("Login")
        .navigationDestination(isPresented: $navigate) {
            MenuView()
        }
    }
}

// MARK: - Models
struct Food: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var price: Double
    var image: String
    var quantity: Int = 0
}

@Observable
class Cart {
    var items: [Food] = []
    var total: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
}

// MARK: - Menu Page
struct MenuView: View {
    @State private var cart = Cart()
    @State private var navigateToCart = false
    
    @State private var foods: [Food] = [
        Food(name: "Pizza", price: 12.49, image: "pizza"),
        Food(name: "Greek Salad", price: 7.99, image: "salad"),
        Food(name: "Tacos", price: 10.99, image: "tacos")
    ]
    
    // 🔽 Locations for dropdown
    let locations = ["Davis", "Capen", "Knox", "Vlemens", "Park Hall", "Lockwood"]
    @State private var selectedLocation = "Davis"
    
    var body: some View {
        VStack {
            // MARK: - Header with location dropdown
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.red)
                    Text("Select a Location")
                        .font(.headline)
                    Spacer()
                }
                
                Picker("Choose your location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            }
            .padding()
            
            // MARK: - Food List
            List {
                ForEach(foods.indices, id: \.self) { index in
                    HStack {
                        Image(foods[index].image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 3)
                        
                        VStack(alignment: .leading) {
                            Text(foods[index].name)
                                .font(.headline)
                            Text("$\(foods[index].price, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Stepper(value: $foods[index].quantity, in: 0...99) {
                            Text("\(foods[index].quantity)")
                                .font(.headline)
                                .frame(minWidth: 20)
                        }
                        .labelsHidden()
                        .frame(width: 100)
                        .onChange(of: foods[index].quantity) { newValue in
                            syncCart(with: foods[index], quantity: newValue)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6))
            
            // MARK: - Place Order Button
            Button {
                navigateToCart = true
            } label: {
                Text("Place Order for \(selectedLocation) (\(cart.items.reduce(0) { $0 + $1.quantity }))")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding()
        }
        .navigationDestination(isPresented: $navigateToCart) {
            CartView(cart: cart)
        }
        .navigationTitle("Menu")
    }
    
    private func syncCart(with food: Food, quantity: Int) {
        if let i = cart.items.firstIndex(where: { $0.name == food.name }) {
            if quantity == 0 {
                cart.items.remove(at: i)
            } else {
                cart.items[i].quantity = quantity
            }
        } else if quantity > 0 {
            var f = food
            f.quantity = quantity
            cart.items.append(f)
        }
    }
}
// MARK: - Cart Page
struct CartView: View {
    @Bindable var cart: Cart
    @State private var navigateToThankYou = false
    
    var body: some View {
        VStack {
            Text("CART")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            if cart.items.isEmpty {
                Text("Your cart is empty")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(cart.items) { item in
                    HStack {
                        Image(item.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text("$\(item.price, specifier: "%.2f") x \(item.quantity)")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                            .bold()
                    }
                }
            }
            
            HStack {
                Text("Total:")
                    .font(.headline)
                Spacer()
                Text("$\(cart.total, specifier: "%.2f")")
                    .font(.headline)
            }
            .padding()
            
            Button("Pay Now") {
                navigateToThankYou = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding()
        }
        .navigationDestination(isPresented: $navigateToThankYou) {
            ThankYouView()
        }
        .navigationTitle("Cart")
    }
}

// MARK: - Thank You Page
struct ThankYouView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("Thank You!")
                .font(.largeTitle)
                .bold()
            
            Text("for your payment")
                .foregroundColor(.gray)
            
            ProgressView(value: 0.4)
                .tint(.green)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                Label("Order Placed", systemImage: "list.clipboard")
                    .foregroundColor(.green)
                Label("Preparing", systemImage: "bell")
                    .foregroundColor(.gray)
                Label("Order Picked", systemImage: "figure.run")
                    .foregroundColor(.gray)
            }
            .font(.headline)
            .padding()
        }
        .padding()
    }
}
