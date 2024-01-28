//
//  Bezier+LookupTable.swift
//  Bezier+LookupTable
//
//  Created by Zakk Hoyt on 9/8/21.
//

import CoreGraphics
import Foundation

extension Bezier {
    struct LookupTable {
        struct Sample: CustomStringConvertible, CustomDebugStringConvertible, Encodable {
            let t: CGFloat
            let point: CGPoint
            
            init(
                t: CGFloat,
                point: CGPoint
            ) {
                self.t = t
                // FIXME: @zakkhoyt - It is necessary to invert the y point. This isn't great... need to fix it for realz, not just here
                self.point = CGPoint(x: point.x, y: 1.0 - point.y)
            }
            
            var description: String {
                "t: \(t) point: \(point.x)"
            }
            
            var debugDescription: String {
                "input(t): \(t) output(point): \(point.x)"
            }
            
            enum CodingKeys: CodingKey {
                case t
                case point
            }
            
            func encode(to encoder: any Encoder) throws {
                var container: KeyedEncodingContainer<Bezier.LookupTable.Sample.CodingKeys> = encoder.container(keyedBy: Bezier.LookupTable.Sample.CodingKeys.self)
                try container.encode(t, forKey: Bezier.LookupTable.Sample.CodingKeys.t)
                try container.encode(point, forKey: Bezier.LookupTable.Sample.CodingKeys.point)
            }
        }

        let samples: [Sample]

        init(
            controlPoints: [CGPoint],
            numberOfSamples: Int
        ) throws {
            self.samples = try (0..<numberOfSamples)
                .map { CGFloat($0) / CGFloat(numberOfSamples - 1) } // convert to t in 0.0 ... 1.0
                .compactMap { try Bezier.solve(points: controlPoints, t: $0) }
                .map { LookupTable.Sample(t: $0.t, point: $0.point) }
//            print("jsonRepresentation: \(jsonRepresentation)")
//            print("arrayXRepresentation: \(arrayXRepresentation)")
//            print("arrayYRepresentation: \(arrayYRepresentation)")
//            print("arrayPointsRepresentation: \(arrayPointsRepresentation)")
        }
        
        var jsonRepresentation: String {
            array(data: samples)
        }

        var arrayXRepresentation: String {
            array(data: samples.map { $0.point.x })
        }

        var arrayYRepresentation: String {
            array(data: samples.map { $0.point.y })
        }

        var arrayPointsRepresentation: String {
            array(data: samples.map { $0.point })
        }
        
        private func array(data: [some Encodable]) -> String {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let data = try encoder.encode(data)
                guard let string = String(data: data, encoding: .utf8) else {
                    fatalError("failed ot convert data to string")
                }
                return string
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
