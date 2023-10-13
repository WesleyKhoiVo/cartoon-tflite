package com.mzm.sample.cartoongan.fragments

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.os.SystemClock
import android.view.*
import android.widget.Toast
import androidx.core.graphics.drawable.toBitmap
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.navArgs
import com.bumptech.glide.Glide
import com.mzm.sample.cartoongan.ImageUtils
import com.mzm.sample.cartoongan.MainActivity
import com.mzm.sample.cartoongan.R
import com.mzm.sample.cartoongan.ml.WhiteboxCartoonGanInt8
import kotlinx.android.synthetic.main.fragment_selfie2cartoon.*
import kotlinx.coroutines.*
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.model.Model
import java.io.File
import java.text.SimpleDateFormat
import java.util.*

/**
 * A simple [Fragment] subclass.
 * Use the [CartoonFragment.newInstance] factory method to
 * create an instance of this fragment.
 *
 * This is where we show both the captured input image and the output image cartoonized by the tflite model
 */
class CartoonFragment : Fragment() {

    private val args: CartoonFragmentArgs by navArgs()
    private lateinit var filePath: String
    private var modelType: Int = 0

    private val parentJob = Job()
    private val coroutineScope = CoroutineScope(Dispatchers.Main + parentJob)

    private fun getOutputAsync(bitmap: Bitmap): Deferred<Pair<Bitmap, Long>> =
        // use async() to create a coroutine in an IO optimized Dispatcher for model inference
        coroutineScope.async(Dispatchers.IO) {

            // GPU delegate
            val options = Model.Options.Builder().setDevice(Model.Device.NNAPI).build()

            // Input
            val sourceImage = TensorImage.fromBitmap(bitmap)

            // Output
            val cartoonizedImage: TensorImage
            val startTime = SystemClock.uptimeMillis()

            cartoonizedImage = inferenceWithInt8Model(sourceImage, options)

            // Note this inference time includes pre-processing and post-processing
            val inferenceTime = SystemClock.uptimeMillis() - startTime
            val cartoonizedImageBitmap = cartoonizedImage.bitmap

            return@async Pair(cartoonizedImageBitmap, inferenceTime)
        }

    // Run inference with the int8 tflite model
    private fun inferenceWithInt8Model(sourceImage: TensorImage, options: Model.Options): TensorImage {
        val model = WhiteboxCartoonGanInt8.newInstance(requireContext(), options)

        // Runs model inference and gets result.
        val outputs = model.process(sourceImage)
        val cartoonizedImage = outputs.cartoonizedImageAsTensorImage

        // Releases model resources if no longer used.
        model.close()

        return cartoonizedImage
    }
    private fun updateUI(outputBitmap: Bitmap, inferenceTime: Long) {
        progressbar.visibility = View.GONE
        imageview_output?.setImageBitmap(outputBitmap)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setHasOptionsMenu(true) // enable toolbar

        retainInstance = true
        filePath = args.rootDir
        modelType = args.modelType
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_selfie2cartoon, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val photoFile = File(filePath)

        val selfieBitmap = BitmapFactory.decodeFile(filePath)
        coroutineScope.launch(Dispatchers.Main) {
            val (outputBitmap, inferenceTime) = getOutputAsync(selfieBitmap).await()
            updateUI(outputBitmap, inferenceTime)
        }
    }
    override fun onDestroy() {
        super.onDestroy()
        // clean up coroutine job
        parentJob.cancel()
    }
    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        inflater.inflate(R.menu.menu_main, menu)
        super.onCreateOptionsMenu(menu, inflater)
    }
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.action_save -> saveCartoon()
        }
        return super.onOptionsItemSelected(item)
    }
    private fun saveCartoon(): String {
        val cartoonBitmap = imageview_output.drawable.toBitmap()
        val file = File(MainActivity.getOutputDirectory(requireContext()), "image_cartoon.jpg")

        ImageUtils.saveBitmap(cartoonBitmap, file)
        Toast.makeText(context, "saved to " + file.absolutePath.toString(), Toast.LENGTH_SHORT).show()

        return file.absolutePath
    }
}