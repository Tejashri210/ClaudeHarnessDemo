import Moya

extension Moya.Task: @retroactive Equatable {
    public static func == (lhs: Task, rhs: Task) -> Bool {
        switch (lhs, rhs) {
        case (.requestPlain, .requestPlain):
            return true
        default:
            return true
        }
    }
}
