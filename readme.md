# OpenFit

Working towards open source patterns for jeans, based on traditional pattern making techniques, new pattern making algorithms, and 3d mesh-driven approaches. We're also exploring the possibilities of automated measurement as input to pattern making tools, and as the basis of 3d meshes.

![](http://farm8.staticflickr.com/7394/9088577239_4dcdc3d396_o.png)

*By the Book* uses a pattern drafting algorithm found in [Threads Magazine: Fitting for Every Figure](http://www.amazon.com/Threads-Fitting-Every-Figure-Magazine/dp/B00E8V3N7Y). *Draft from Center* uses our own pattern algorithm.  *Measure* is a Kinect-driven measurement tool. Sample chromakey legging front and side photos can be found in the [Open Fit Flickr Pool](http://www.flickr.com/groups/2202673@N25/pool/with/9263143866/#photo_9263143866).

A collaboration between [Kyle McDonald](http://kylemcdonald.net/) and [Lisa Kori Chung](http://lisakori.net/).


## Notes for Measuring

### Set the scene

You will need to wear a pair of chromakey/neon leggings while measuring. The Kinect should be placed on a level surface around crotch height, and waist to feet of the subject should clearly take the majority of the frame. Light on the subject should be diffused, not harsh. A black background works well, but anything neutral or distincly different from the color of the leggings should work. 

### Test using the Green Screen helper app

Run the application `Measure` and make the application window fullscreen. Click `Use Kinect` to turn on the Kinect (images should appear on the left hand side). Make sure to get the feet to the waist into the frame and keep hands and other obstructions out of the way. Click `Sample Front` to take a images (color and depth) of your subject facing the Kinect and `Sample Side` to take images from the side. 

Click "Export". It will bring up a save file dialog. Upon export, there should be four images in the folder and a json file. Copy the color and depth front pair of images into the bin/data folder of the application `GreenScreen`. Run `GreenScreen` and adjust the parameters to get an even mask of the leggings. 

 - Start by adjusting the sliders "Hue center" and "Hue range" to select the color hue of the leggings, and a tolerance (Hue range) parameter (the smaller you can make the range without losing the leggings, the better).
 - Adjust background threshold to remove anything behind the person in the frame.
 - Adjust Saturation/Value padding to isolate the leggings from the rest of the picture (low value works best)
 - Adjust the erosion and dilation sliders to fill in holes in the found contour

Take note of parameter values as they will be of use in the next step. Adjust the scene and try sampling images again if a clear mask cannot be made. 

### Measuring

The application `Measure` derives your pants measurements by using computer vision to isolate the contours of the pants and sample the position of the relevant measurement locations (hips, butt, thighs, midthighs, knees, ankles).

The `Measure` app has four images in the default folder (front and side, color and depth). These can be replaced with your own photos. 

When the `Measure` app is loaded , it will automatically load saved parameter values, if there are any. Parameters can be set using values derived in the `GreenScreen` application. Pressing `s` will save values and overwrite the previous save, pressing `l` will load values. 

Hold `1`,`2`, and `3` respectively to set the location of floor points 1,2, and 3. The three floor points give us the plane of reference; if all three points are evenly spaced on the floor around the subject it will be more accurate than if two points are directly adjacent to each other.  

Adjust "Hip", "Ankle", and "HipSlope" first. "Hipslope" is viewable on the side and allows the user to make the rise of the pants higher in the back than the front. 

Once those are set, "Calf", "Knee", "Midthigh", "Thigh", and "Butt" can be set. 

Body parts
 * Hips - Top outer corners of the leggings
 * Butt - widest part of the body
 * Thigh - line up with crotch
 * Midthigh - between crotch and knees
 * Knees - knees
 * Ankles - ankles

Once, the correct contour points are lined on the outside of the leggings click "Export". It will bring up a save file dialog.

A folder will be created with 4 pictures (color and depth, front and side) and a new file called `measurements.json`. This file has the correct inch measurements, which can be exported to the Processing pattern generating applications.


### Notes/bugs

Sometimes the ankleToFloor measurement is wrong. This should be fixed soon. 

In the Measure application, if some of the sliders become inaccessible/nan/infinity, you can reset the sliders by tapping the spacebar.

If the export button doesn't bring up a save dialog, click Shift-S (capital S).