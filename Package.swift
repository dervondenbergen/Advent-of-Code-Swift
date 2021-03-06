// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Advent-of-Code-Swift",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/sindresorhus/Regex", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Helpers"
        ),
        .executableTarget(
            name: "2020/Day01",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day01",
            resources: [
                .copy("input01.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day02",
            dependencies: ["Helpers", "Regex"],
            path: "Sources/2020/Day02",
            resources: [
                .copy("input02.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day03",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day03",
            resources: [
                .copy("input03.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day04",
            dependencies: ["Helpers", "Regex"],
            path: "Sources/2020/Day04",
            resources: [
                .copy("input04.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day05",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day05",
            resources: [
                .copy("input05.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day06",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day06",
            resources: [
                .copy("input06.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day07",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day07",
            resources: [
                .copy("input07.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day08",
            dependencies: ["Helpers", "Regex"],
            path: "Sources/2020/Day08",
            resources: [
                .copy("input08.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day09",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day09",
            resources: [
                .copy("input09.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day10",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day10",
            resources: [
                .copy("input10.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day11",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day11",
            resources: [
                .copy("input11.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day12",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day12",
            resources: [
                .copy("input12.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day13",
            path: "Sources/2020/Day13"
        ),
        .executableTarget(
            name: "2020/Day14",
            dependencies: ["Helpers"],
            path: "Sources/2020/Day14",
            resources: [
                .copy("input14.txt")
            ]
        ),
        .executableTarget(
            name: "2020/Day15",
            path: "Sources/2020/Day15"
        ),
        .executableTarget(
            name: "2021/Day01",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day01",
            resources: [
                .copy("input01.txt")
            ]
        ),
        .executableTarget(
            name: "2021/Day02",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day02",
            resources: [
                .copy("input02.txt")
            ]
        ),
        .executableTarget(
            name: "2021/Day03",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day03",
            resources: [
                .copy("input03.txt")
            ]
        ),
        .executableTarget(
            name: "2021/Day04",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day04",
            resources: [
                .copy("input04.txt")
            ]
        ),
        .executableTarget(
            name: "2021/Day05",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day05",
            resources: [
                .copy("input05.txt")
            ]
        ),
        .executableTarget(
            name: "2021/Day06",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day06",
            resources: [
                .copy("input06.txt")
            ]
        ),
        .executableTarget(
            name: "2021/Day07",
            dependencies: ["Helpers"],
            path: "Sources/2021/Day07",
            resources: [
                .copy("input07.txt")
            ]
        ),
    ]
)
