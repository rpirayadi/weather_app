// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "weather_app",
	products: [
		.executable(name: "weather_app", targets: ["weather_app"]),
	],
	dependencies: [],
	targets: [
		.executableTarget(name: "weather_app", dependencies: [])
	]
)
