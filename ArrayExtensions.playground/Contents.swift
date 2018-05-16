extension Array {
    
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        var result = initialResult
        for x in self {
            result = try nextPartialResult(result, x)
        }
        return result
    }
    
    func all(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        for x in self {
            if try !predicate(x) {
                return false
            }
        }
        return true
    }
    
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter { try predicate($0) }.count
    }
    
    func indices(where predicate: (Element) throws -> Bool) rethrows -> [Array.Index] {
        var indices: [Array.Index] = []
        for i in 0 ..< self.count where try predicate(self[i]) {
            indices.append(i)
        }
        return indices
    }
    
    func prefix(while predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var result: [Element] = []
        for x in self {
            guard try predicate(x) else {
                return result
            }
            result.append(x)
        }
        
        return result
    }
    
    func drop(while predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var result: [Element] = self
        for x in result {
            if try !predicate(x) {
                return result
            }
            result = Array(result.dropFirst())
        }
        
        return result
    }
    
}

// Examples

print(["1","2","3"].accumulate("", { $0+$1}))

print([1,2,3].all(matching: { 3 > $0 }))

print(["a","c","d"].all { $0 != "d" })

print([1,2,6,9,3].count { $0 < 3})

print([1,2,3,4,1].indices(where: {$0<3}))

print([1,2,3,3,3,7,0].prefix(while: {$0 < 4}))

print([1,2,3,3,3,7,0].drop(while: {$0 < 4}))
