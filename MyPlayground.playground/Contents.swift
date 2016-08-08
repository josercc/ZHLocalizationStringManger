//: Playground - noun: a place where people can play

import UIKit

var set:Set = Set([1,2,2,1])
var set1:Set = Set([2,2])
print(set.intersect(set1))


func setValue(array:[Int],array1:[Int]) -> [Int] {
    return Array(Set(array).intersect(Set(array1)))
}
var time = CFAbsoluteTimeGetCurrent()
print(setValue([1,2,2,1], array1: [2,2]))
print("\(CFAbsoluteTimeGetCurrent() -  time)")