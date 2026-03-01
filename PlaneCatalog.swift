import Foundation

struct PlaneTier: Identifiable {
    let id = UUID()
    let name: String
    let power: String
    let wingspan: String
    let weight: String
    let symbol: String
}

enum PlaneCatalog {
    static let tiers: [PlaneTier] = [
        PlaneTier(name: "Cessna 172", power: "180 hp", wingspan: "36 ft 1 in", weight: "2,450 lbs", symbol: "airplane"),
        PlaneTier(name: "Piper PA-28", power: "180 hp", wingspan: "35 ft 5 in", weight: "2,550 lbs", symbol: "airplane"),
        PlaneTier(name: "Diamond DA40", power: "180 hp", wingspan: "39 ft 2 in", weight: "2,888 lbs", symbol: "airplane"),
        PlaneTier(name: "Cirrus SR20", power: "215 hp", wingspan: "38 ft 4 in", weight: "3,050 lbs", symbol: "airplane"),
        PlaneTier(name: "Beechcraft Bonanza G-36", power: "300 hp", wingspan: "33 ft 6 in", weight: "3,650 lbs", symbol: "airplane"),

        PlaneTier(name: "Cessna 206 Stationair", power: "300 hp", wingspan: "36 ft", weight: "3,600 lbs", symbol: "airplane"),
        PlaneTier(name: "Piper PA-34 Seneca", power: "440 hp", wingspan: "38 ft 10 in", weight: "4,750 lbs", symbol: "airplane"),
        PlaneTier(name: "Beechcraft Baron G58", power: "600 hp", wingspan: "37 ft 10 in", weight: "5,500 lbs", symbol: "airplane"),
        PlaneTier(name: "Pilatus PC-12", power: "1200 hp", wingspan: "53 ft 4 in", weight: "10,540 lbs", symbol: "airplane"),
        PlaneTier(name: "HondaJet HA-420", power: "4,100 lb thrust", wingspan: "39 ft 9 in", weight: "10,600 lbs", symbol: "airplane"),

        PlaneTier(name: "Cessna Citation CJ4", power: "7,242 lb thrust", wingspan: "50 ft 10 in", weight: "17,110 lbs", symbol: "airplane"),
        PlaneTier(name: "Embraer Phenom 300", power: "6,720 lb thrust", wingspan: "52 ft 2 in", weight: "18,387 lbs", symbol: "airplane"),
        PlaneTier(name: "Bombardier Challenger 350", power: "14,646 lb thrust", wingspan: "69 ft", weight: "40,600 lbs", symbol: "airplane"),
        PlaneTier(name: "Gulfstream G280", power: "15,248 lb thrust", wingspan: "63 ft", weight: "39,600 lbs", symbol: "airplane"),
        PlaneTier(name: "Bombardier Global 8000", power: "37,840 lb thrust", wingspan: "104 ft", weight: "114,850 lbs", symbol: "airplane"),

        PlaneTier(name: "Boeing 737", power: "54,600 lb thrust", wingspan: "117 ft 5 in", weight: "174,200 lbs", symbol: "airplane"),
        PlaneTier(name: "Airbus A320", power: "54,000 lb thrust", wingspan: "117 ft 10 in", weight: "169,800 lbs", symbol: "airplane"),
        PlaneTier(name: "Boeing 787", power: "140,000 lb thrust", wingspan: "197 ft 3 in", weight: "560,000 lbs", symbol: "airplane"),
        PlaneTier(name: "Airbus A350", power: "198,000 lb thrust", wingspan: "212 ft 5 in", weight: "617,300 lbs", symbol: "airplane"),
        PlaneTier(name: "Boeing 747-8", power: "266,000 lb thrust", wingspan: "224 ft 7 in", weight: "987,000 lbs", symbol: "airplane"),
        PlaneTier(name: "Airbus A380", power: "280,000 lb thrust", wingspan: "261 ft 8 in", weight: "1,268,000 lbs", symbol: "airplane"
        )
    ]

    static func currentPlane(completedMissions: Int) -> PlaneTier {
        let idx = min(max(completedMissions, 0), tiers.count - 1)
        return tiers[idx]
    }

    static func progress(completedMissions: Int) -> Double {
        guard tiers.count > 1 else { return 1 }
        let clamped = min(max(completedMissions, 0), tiers.count - 1)
        return Double(clamped) / Double(tiers.count - 1)
    }
}
