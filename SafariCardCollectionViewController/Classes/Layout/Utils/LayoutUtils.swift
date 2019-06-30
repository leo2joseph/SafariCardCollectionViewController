//
//  LayoutUtils.swift
//  CSV-Parser
//
//  Created by Son on 6/23/19.
//  Copyright © 2019 Sonracle. All rights reserved.
//

import UIKit

public struct LayoutUtils {
    private static func radians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat.pi / 180.0
    }

    public static func getTransform(
        translateToX: CGFloat,
        translateToY: CGFloat,
        scaleOut: ScaleRatio,
        isRotate: Bool
    ) -> CATransform3D {
        var transform = CATransform3DIdentity
        let angle = CGFloat(55.0)
        // m34 enables 3D on the transform. The divisor determines the distance in the z-direction.
        transform.m34 = 1.0 / -2000.0
        if isRotate {
            transform = CATransform3DRotate(transform, -radians(degrees: angle), 1.0, 0.0, 0.0)
        }
        if scaleOut.x < 1.0 || scaleOut.y < 1.0 || scaleOut.z < 1.0 {
            transform = CATransform3DScale(transform, scaleOut.x, scaleOut.y, scaleOut.z)
        }
        if translateToX != 0.0 || translateToY != 0.0 {
            transform = CATransform3DTranslate(transform, translateToX, translateToY, 0)
        }

        return transform
    }
}
