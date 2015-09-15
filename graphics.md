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
1. After drawing the first pentagon, translate the context so the origin is at the middle of the context.
2. Rotate the context 180 degrees (M_PI).
3. Translate back to the previous origin.
4. Draw a second pentagon.
5. Move all the code to draw both pentagons into a new method.
6. At the begining and end of the method, respectively, save and
   restore the state of the context.
