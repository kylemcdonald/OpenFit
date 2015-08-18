# OpenFit

Working towards open source patterns for jeans, based on traditional pattern making techniques, new pattern making algorithms, and 3d mesh-driven approaches. We're also exploring the possibilities of automated measurement as input to pattern making tools, and as the basis of 3d meshes.

![](http://farm8.staticflickr.com/7394/9088577239_4dcdc3d396_o.png)

*By the Book* uses a pattern drafting algorithm found in [Threads Magazine: Fitting for Every Figure](http://www.amazon.com/Threads-Fitting-Every-Figure-Magazine/dp/B00E8V3N7Y). *Draft from Center* uses our own pattern algorithm.  *Measure* is a Kinect-driven measurement tool. Sample chromakey legging front and side photos can be found in the [Open Fit Flickr Pool](http://www.flickr.com/groups/2202673@N25/pool/with/9263143866/#photo_9263143866).

A collaboration between [Kyle McDonald](http://kylemcdonald.net/) and [Lisa Kori Chung](http://lisakori.net/).


## Instructions for measuring applications

1) Find and put on bright chromakey/neon leggings. Wear them in front of a background with high contrast from the leggings color (having a black backdrop works best if possible);

2) Run the application `MeasureRealtime`. Take one picture from the front, and one profile picture from the side, making sure to get the entire leggings into the frame and keeping your hands and other obstructions not in front of the leggings.  

3) After this, you should have produced 4 pictures in the bin/data folder of `MeasureRealtime` -- `0-color.png`, `0-depth.png`, `1-color.png`, and `1-depth.png`.  Copy these images into the bin/data folder of the application `Measure` (and optionally, `GreenScreen`).

4) The application `Measure` derives your pants measurements by using computer vision to isolate the contours of the pants and sample the position of the relevant measurement locations (hips, butt, thighs, midthighs, knees, ankles). To do this you must adjust the parameters in the sliders to the left to get the right values. You may optionally use `GreenScreen` to do this first and copy the values, or you may use `Measure` directly.

 - Start by adjusting the sliders "Hue center" and "Hue range" to select the color hue of the leggings, and a tolerance (Hue range) parameter (the smaller you can make the range without losing the leggings, the better).
 - Adjust background threshold to remove anything behind the person in the frame.
 - Adjust Saturation/Value padding to isolate the leggings from the rest of the picture (low value works best)
 - Adjust the erosion and dilation sliders to fill in holes in the found contour
 - Finally, adjust the horizontal lines corresponding to "Hip", "Ankle", "Calf", "Knee", "Midthigh", "Thigh", and "Butt" to properly line up with the body.

Body parts
 * Hips - Top corners of the leggings
 * Butt - widest part of the leggings
 * Thigh - line up with crotch
 * Midthigh - between crotch and knees
 * Knees - knees
 * Ankles - ankles

5) You should have a picture that looks approximately like this, where the correct contour points are lined on the outside of the leggings.

Click "Export". It will bring up a save file dialog.

You should now have a folder with the 4 pictures from step 3 and a new file called `measurements.json`. This file has the correct inch measurements, which can be exported to the Processing pattern generating applications.


### Notes/bugs

In the Measure application, occasionally some of the sliders become inaccessible/nan/infinity. This is a bug which will be fixed in a future release. For now you can reset the sliders by tapping the spacebar.

Also, if the export button doesn't bring up a save dialog, click Shift-S (capital S).
