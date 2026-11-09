import SwiftUI

// Tamagotchi New Juke — original iPhone SwiftUI prototype.
// Create an iOS App project in Xcode, then replace the generated App file
// with this file. Remove any duplicate @main App declaration.
@main
struct NewJukeApp: App {
    var body: some Scene {
        WindowGroup { JukePetView() }
    }
}

struct JukePetView: View {
    @AppStorage("newJukeHunger") private var hunger = 70
    @AppStorage("newJukeJoy") private var joy = 75
    @AppStorage("newJukeEnergy") private var energy = 80
    @State private var blink = false

    private var mood: String {
        if energy < 25 { return "Sleepy" }
        if hunger < 25 { return "Hungry" }
        if joy < 25 { return "Bored" }
        return "Happy"
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("NEW JUKE").font(.system(size: 32, weight: .black, design: .rounded))
            Text("Your pocket companion").foregroundStyle(.secondary)
            ZStack {
                RoundedRectangle(cornerRadius: 36)
                    .fill(Color(red: 0.16, green: 0.08, blue: 0.25))
                    .frame(height: 310)
                VStack(spacing: 22) {
                    HStack(spacing: 45) {
                        eye
                        eye
                    }
                    if mood == "Happy" {
                        Capsule().stroke(.cyan, lineWidth: 8).frame(width: 65, height: 25)
                    } else {
                        Capsule().fill(.cyan).frame(width: 25, height: 30)
                    }
                }
            }
            Text(mood).font(.title2.bold())
            stat("Food", hunger)
            stat("Joy", joy)
            stat("Energy", energy)
            HStack(spacing: 10) {
                Button("Feed") { hunger = min(100, hunger + 15) }
                Button("Play") { joy = min(100, joy + 15); energy = max(0, energy - 5) }
                Button("Rest") { energy = min(100, energy + 20) }
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            Spacer(minLength: 0)
        }
        .padding(22)
        .background(Color.black)
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                blink = true
                try? await Task.sleep(for: .milliseconds(160))
                blink = false
            }
        }
    }

    private var eye: some View {
        RoundedRectangle(cornerRadius: blink ? 2 : 15)
            .fill(.white)
            .frame(width: 36, height: blink ? 5 : 55)
            .frame(height: 55)
    }

    private func stat(_ label: String, _ value: Int) -> some View {
        HStack {
            Text(label).frame(width: 65, alignment: .leading)
            ProgressView(value: Double(value), total: 100)
                .tint(.cyan)
            Text("\(value)").monospacedDigit().frame(width: 32)
        }
    }
}
