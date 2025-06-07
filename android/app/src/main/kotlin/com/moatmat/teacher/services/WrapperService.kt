package com.moatmat.teacher.services
import android.graphics.drawable.shapes.Shape
import org.opencv.core.Mat
import org.opencv.calib3d.Calib3d
import org.opencv.core.MatOfPoint
import org.opencv.core.MatOfPoint2f
import org.opencv.core.Point
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc
import kotlin.math.hypot

class WrapperService {

    fun warpImageBasedOnPoints(srcImage: Mat, contour: MatOfPoint): Mat {
        //
        // Order points
        val points = orderPoints(getCornerPoints(contour))
        //
        // Convert ordered points from MatOfPoint2f to Array of Point
        val pointsArray = points.toArray()
        //
        // Ensure we have exactly 4 points
        if (pointsArray.size != 4) {
            throw IllegalArgumentException("The contour must have exactly 4 points")
        }
        // Calculate the width based on the distance between top-left and top-right
        val width = hypot(
            (pointsArray[1].x - pointsArray[0].x).toDouble(),
            (pointsArray[1].y - pointsArray[0].y).toDouble()
        )
        // Calculate the height based on the distance between top-left and bottom-left
        val height = hypot(
            (pointsArray[3].x - pointsArray[0].x).toDouble(),
            (pointsArray[3].y - pointsArray[0].y).toDouble()
        )
        // Define destination points for the 'warpPerspective'
        val dstPoints = MatOfPoint2f(
            Point(0.0, 0.0),
            Point(width.toDouble(), 0.0),
            Point(width.toDouble(), height.toDouble()),
            Point(0.0, height.toDouble(),)
        )
        // Get the perspective transform matrix
        val perspectiveTransform = Imgproc.getPerspectiveTransform(points, dstPoints)
        // Apply the perspective warp
        val warpedImage = Mat()
        Imgproc.warpPerspective(srcImage, warpedImage, perspectiveTransform, Size(width, height))

        return warpedImage
    }


    // Ensures 'orderPoints' accepts and outputs MatOfPoint2f
    private fun orderPoints(pts: MatOfPoint2f): MatOfPoint2f {
        val srcPoints = pts.toArray().sortedWith(compareBy({ it.y }, { it.x }))
        val result = arrayOfNulls<Point>(4)
        result[0] = srcPoints.minByOrNull { it.x + it.y } // Top-left
        result[1] = srcPoints.maxByOrNull { it.x - it.y } // Top-right
        result[2] = srcPoints.maxByOrNull { it.x + it.y } // Bottom-right
        result[3] = srcPoints.minByOrNull { it.x - it.y } // Bottom-left
        return MatOfPoint2f(*result.filterNotNull().toTypedArray())
    }

    private fun getCornerPoints(biggestContour: MatOfPoint): MatOfPoint2f {
        //
        val curve = MatOfPoint2f(*biggestContour.toArray())
        // Calculate the arc length
        val length = Imgproc.arcLength(curve, true)
        //
        val approxCurve = MatOfPoint2f()
        //
        Imgproc.approxPolyDP(curve,approxCurve,0.02*length,true)
        //
        return approxCurve
    }
}