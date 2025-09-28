package com.prognosis.teacher.services
import org.opencv.core.Core
import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.core.MatOfPoint
import org.opencv.core.Point
import org.opencv.core.Rect
import org.opencv.core.Scalar
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc

class MatService {

    public  fun reSize(mat:Mat,size:Size):Mat{
        val newMat = Mat();
        Imgproc.resize(mat, newMat, size);
        return newMat;
     }

    public  fun rotate(mat: Mat, rotationCode:Int):Mat{

        // ROTATE_90_CLOCKWISE = 0,
        // ROTATE_180 = 1,
        // ROTATE_90_COUNTERCLOCKWISE = 2;

        val newMat = Mat()
        Core.rotate(mat, newMat, rotationCode)
        return newMat
    }

    public  fun praperImage(mat:Mat):Mat{
        //
        val grayScaleImg =Mat();
        // to gray sale
        Imgproc.cvtColor(mat,grayScaleImg,Imgproc.COLOR_BGR2GRAY);
        //
        val blurredImg =Mat();
        //  add blur to image
        Imgproc.GaussianBlur(grayScaleImg,blurredImg,Size(5.0, 5.0),1.0);
        //
        //        //
        val threshold=Mat();
        //
        Imgproc.adaptiveThreshold(
            blurredImg,
            threshold,
            255.0,
            Imgproc.ADAPTIVE_THRESH_MEAN_C,
            Imgproc.THRESH_BINARY_INV,
            109,
            9.0,
        );
        //
        // Applying Canny Edge Detection
        val edges = Mat()
        Imgproc.Canny(threshold, edges, 100.0, 200.0)
        //
        val dilateImg=dilateImg(threshold)
        val morphImg = morphImg(dilateImg);
        //
        return  morphImg;
    }



    public  fun drawContours(mat: Mat, contours: List<MatOfPoint>): Mat {
        //
        val color = Scalar(0.0, 255.0, 0.0, 0.0);
        //
        Imgproc.drawContours(mat, contours, -1, color, 20);
        //
        return mat;
    }

    public  fun cropImage(mat: Mat, widthRatio: Double, heightRatio: Double): Mat {

        // Get original dimensions
        val originalWidth = mat.width()
        val originalHeight = mat.height()

        // Calculate new dimensions based on ratios
        val newWidth = (originalWidth * widthRatio).toInt()
        val newHeight = (originalHeight * heightRatio).toInt()

        // Calculate top-left corner for centered crop
        val x = (originalWidth - newWidth) / 2
        val y = (originalHeight - newHeight) / 2

        // Define the region of interest (ROI)
        val roi = Rect(x, y, newWidth, newHeight)

        // Extract the ROI from the original image
        return Mat(mat, roi)
    }

    public  fun getCenterUsingMoments(contour: MatOfPoint): Point {
        // Calculate the moments of the contour
        val moments = Imgproc.moments(contour)

        // Calculate the centroid using the moments
        val centerX = moments.m10 / moments.m00
        val centerY = moments.m01 / moments.m00

        // Return the center as a Point
        return Point(centerX, centerY)
    }

    private fun dilateImg(img: Mat): Mat {
        // Create a 3x3 matrix filled with zeros
        val kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, Size(2.0, 2.0))
        // Apply Dilation
        val imgDilate = Mat()
        Imgproc.dilate(img, imgDilate, kernel)
        return imgDilate
    }

    private fun morphImg(img: Mat): Mat {
        // Create an 8x8 matrix filled with zeros
        val kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, Size(2.0, 2.0))
        // Apply Morphological Transformation (Closing)
        val imgMorph = Mat()
        Imgproc.morphologyEx(img, imgMorph, Imgproc.MORPH_CLOSE, kernel)
        return imgMorph
    }

    public  fun toBytes(mat: Mat): ByteArray {
        // Encode the Mat to a byte array (JPG format here, you can choose another format)
        val byteMat = MatOfByte()
        Imgcodecs.imencode(".jpg", mat, byteMat)
        val byteArray = ByteArray(byteMat.total().toInt() * byteMat.elemSize().toInt())
        byteMat.get(0, 0, byteArray)
        return byteArray
    }

    public  fun fromBytes(byteArray: ByteArray): Mat {
        // Create a MatOfByte from the byte array
        val matOfByte = MatOfByte(*byteArray)
        // Decode the MatOfByte to a Mat
        return Imgcodecs.imdecode(matOfByte, Imgcodecs.IMREAD_COLOR)
    }

    public  fun praperImageToCount(mat: Mat):Mat{
        //
        //
        val grayScaleImg =Mat();
        // to gray sale
        Imgproc.cvtColor(mat,grayScaleImg,Imgproc.COLOR_BGR2GRAY);
        //
        var thresholded=Mat()
        //
        Imgproc.adaptiveThreshold(
            grayScaleImg,
            thresholded,
            255.0,
            Imgproc.ADAPTIVE_THRESH_MEAN_C,
            Imgproc.THRESH_BINARY_INV,
            191,
            13.0,
        );
        var cropped=Mat()
        //
        cropped=cropImage(thresholded,0.60,0.60)
        return  cropped
    }

    public fun countNonZero(mat: Mat): Int {
        //
        var ready=Mat()
        //
        ready=praperImageToCount(mat)
        //
        return Core.countNonZero((ready))
    }

}