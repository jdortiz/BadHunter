# Graphics

## Set up the canvas
Prepare a view that will be used as the canvas for drawing and learn
how to use Core Graphics.
1. Add a UIView to the credits view controller. Use it instead of the
   icon image.
2. Make the background of the view slightly gray so it can be found easily.
3. Set its size to be 200x200
4. Set the rest of the constraints so it can substitute the
   icon. Don't worry about shrinking in the smaller devices.
5. Create a subclass of UIView and call it CanvasView.
6. Change the class of the view in the storyboard so it is CanvasView.
7. Change the IBOutlet so that it points to the new view.
8. Run and check that every

## Draw simple shapes
Draw the simplest stuff.
Rectangles, circles lines, paths. Change stroke color, width, fill color
1. Lets start with a Rectangle. In drawRect:, lets create one by form the original
   one that is 5 points smaller per side with CGRectInset. Call it
   firstRectangle.
2. Create a UIBezierPath with with the new rectangle.
3. Create a purple instance of UIColor and set it to fill in the
   current graphics context.
4. Use the path to fill.
5. Run it and see the results.
6. Generate a second rectangle that is a reduced version of the
   previous one. Call it secondRect.
7. With it, create a BezierPath, a rectangle with rounded corners with
   secondRect and a radius of 5.
8. Set the red as the fill color and fill using the new pattern.
9. Run it and see the results.
10. Generate a third rectangle that is a reduced version of the
   previous one. and offset by (35,0). Call it thirdRect.
11. With it, create a BezierPath, an oval path with
    thirdRect and a radius of 5.
12. Set the red as the fill color and fill using the new pattern.
13. Run it and see the results. Note the third path is clipped.
14. Finally, let's draw a polyline. Create a new BezierPath. Move it
    to the center of the view (moveToPoint:) and draw segments to any
    points (addLineToPoint:).
15. In this case create a color to set the stroke color. And use the
    Bezier path to make the strokes.
16. Run it and see the results.


Notes:
- Cliping outside of the view is an expensive operation.

## Create a more relevant path
Draw a pentagon like the ones that there were in the icon with some
extra decorations.
1. Delete all the previous drawing code from drawRect:.
2. Create a method that returns a CGPoint provided with a radius, the
   number of the point and the total number of points of a regular
   polygon.
3. Create a Bezier path that generates a regular pentagon using the
   previous function.
4. Set the color of the stroke to (H:352/360, S:1.0, B:0.77).
5. Draw the path.
6. Let's add some decorations below the corners of the pentagon. Lets
   make darkGrey circles of radius 3.0.

## Use CGContext directly
Unleash the full power of the Core Graphics API.
1. Obtain a reference to the current graphics context.
2. Create a CGMutablePathRef to store the pentagon.
3. Use the C functions to create the equivalent path with the
   generated corners.
4. Add the path to the context and release it.
5. Set the line width of the context and the color of the stroke.
6. Stroke the path of the context.
7. Comment out the previous code.


## Create more modular drawing code
Each part of the drawing can be decomposed and its usage shouldn't
affect to the state of the context.
1. Preserve the state of the context before start creating the path,
   particularly before modifying properties like the stroke color or
   the line width.
2. Restore the state of the context right after having stroked the path.
3. Extract everything from save to restore into a separate method.
4. Inside of the loop that adds the lines to the pentagon create
   another mutable path for each circle and fill it.
5. Extract the expressions that draw the circle into a new method.
6. At the begining and end of the method, respectively, save and
   restore the state of the context.
7. Remove the old context.

## Take advantage of modularity
Now that the code to draw is more modular, it is easier to make more
complex drawing and to understand how they are done.
1. After drawing the first pentagon, translate the context so the
   origin is at the middle of the context.
2. Rotate the context 180 degrees (M_PI).
3. Translate back to the previous origin.
4. Draw a second pentagon.
5. Move all the code to draw both pentagons into a new method.
6. At the begining and end of the method, respectively, save and
   restore the state of the context.

## Draw the character
Complete the drawing for the icon. Use as a reference the original
image.
1. Make an ellipse embedded in a rectagle that is (150, 100). Draw it
   at (25,40).
2. Fill it.
3. Extract the new ellipse for the head into a new method.
4. At the begining and end of the method, respectively, save and
   restore the state of the context.
5. Set the fill color to black.
6. Draw the eyes with elipses of (60.0, 40). The horizontal position of
   the right one should be 4 points to the right of the horizontal
   center and its vertical center should be at one fourth the height
   of the image.
7. The second one should be in the simetrical position vertically.
8. Notice that they are not shown because the color is the same as the
   one for the main ellipse. In order to get the eyes to be empty, use
   the kCGPathEOFill option when drawing the path.
9. Make the right eye to be rotated from its center 20 degrees
   counter-clockwise, and the left one 20 degrees clockwise.
10. The 4 teeth are rectangles of size (20,30) displayed at (36.0,
    120.0), (72.0, 128.0), (108.0, 128.0), and (144.0, 120.0).
11. Note that the intersections of the teeth with the head is not
    shown. Put them in a different path.

## Make the view transparent
There are some things that need to be done if we want our background
to be transparent.
1. Change back background color of the view to transparent.
2. Run it and check if the view is transparent to the fire effect.
3. Try to find which path is responsible for this issue.
4. Right after getting the current context in order to use it to draw,
   clear with CGContextClearRect(context, rect);
5. Run it and check if the view is transparent to the fire effect.
6. Override the designated initializer initWithCoder and clear the
   background of the view.
7. Run it and check if the view is transparent to the fire effect.


## Save image to PDF
It is very useful to be able to generate a PDF from our content.
1. In a new method, create a NSMutableData object to hold the contents
   of the PDF.
2. Make a data consumer (CGDataConsumerRef) from the previous object.
3. Define the rectangle that will contain the contents with bounds of
   this view.
4. Create a PDF context with the data consumer and the rectangle for
   the contents.
5. Push this CG context so it becomes the current context.
6. Begin a new PDF page.
7. Make the drawing with the previously defined methods.
8. End the page.
9. Close the context.
10. Pop the CG context.
11. Release the context and the data consumer.
12. Write the NSMutable data to a URL.
13. Invoke this method in draw method after the normal drawing.
14. Run it in the simulator and look for this file in the filesystem
    and open it.
15. Comment out the invokation to the pdf creation since this
    shouldn't happen everytime.

## Make the custom view more accessible from Interface Builder
1. In the header of the custom view, right before the first line of
   the interface definition add a line saying IB_Designable.
2. Go to Xcode and notice that it can be visualized there although it
   takes a while. Notice that the problems with the background aren't
   solved here.
3. Add two properties one for the color of the lines of the
   pentagons, another one for its width.
4. Before the class of the properties add IBInspectable. Notice that
   the properties are now available when you inspect the view.
5. Use these properties in the drawing code.
6. Now make some changes in the inspector and verify that the preview changes.
7. Run it and check the results.
8. In order to set default values for this properties, do that in the
   initWithCoder overriden initializer.
