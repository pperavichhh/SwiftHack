import SwiftUI

struct HomepageView: View {
    let username = "John"
    var days = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hi, \(username)!")
                .font(Font.custom("SF Pro", size: 28).weight(.bold))
                .padding(.leading)
                .lineSpacing(13)
                .foregroundColor(.black)
            
            Text("You have been here for \(days) days")
                .font(Font.custom("SF Pro", size: 16))
                .padding([.leading, .bottom])
                .lineSpacing(13)
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
            
            ZStack(alignment: .top) { // Rectangle layers
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 309, height: 276)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                        radius: 4,
                        x: 0,
                        y: 4
                    )
                
                VStack { // Text and Image in Rectangle layers
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.black)
                            .padding(.trailing, 8) // Adjust padding as needed
                        
                        Text("Today Weight")
                            .font(Font.custom("SF Pro", size: 15).weight(.bold))
                            .multilineTextAlignment(.leading)
                            .padding([.top, .bottom, .trailing])
                            .lineSpacing(13)
                            .foregroundColor(.black)
                    }
                    
                    HStack(spacing: 0) {
                        // Add your content inside the HStack if needed
                    }
                    .padding(
                        EdgeInsets(top: 3.44, leading: 2.06, bottom: 3.44, trailing: 2.03)
                    )
                    .frame(width: 22, height: 22)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align to the top
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // Align to top left corner
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
