# Animations

## Add a simple animation on the logo

Let's start with animations. Let's create the simplest one.

1. Create a custom class for the credits ("CreditsViewController").
2. Assign the class to its scene in the storyboard.
3. Create an IBOutlet for the icon.
4. In viewDidLoad set the alpha of the image to 0.
5. In viewDidAppear set the alpha of the image to 1 inside of an
   animation block with duration 0.5 (animateWithDuration:animations:).
6. Change it to use the method with more options in order to have an
   easy out curve.
7. Change it to use the method with the spring options and use 1.0 as
   the damping parameter and 0.1 as the initial velocity.

## Animate the icon with 2D transforms

One of the most powerful ways to animate views in iOS. This example
shows some implementations.

1. Define a CGAffineTransform matrix to scale down the icon to a 10%
   and apply it to the transform property of the icon.
2. Set it to the identity transform in the animation block so it comes
   back to its normal size.
3. Run it and watch the combined effect of both things being animated.
4. Add a rotation of 180 degrees to the transformation. Use the
   constant `M_PI` to express the 180 degrees in radians. Apply the
   scaling transformation to the rotation transformation.
5. Run it and watch the combined effect.
6. Add translation transformation to the previous transformation
   (-100,-100). Apply the rotation transformation to the translation
   and the scaling to the result of the previous operation.
7. Run it and watch the combined effect.
8. Revert the order of the transforms. Apply the rotation to the
   scaling transformation and the translation to the result of the
   previous operation.
9. Run it and watch the combined effect. Try to explain the result.
10. Revert it to the previous order of transformations.

## Animate positions using constraints

If you use autolayout you have to play by the rules and animate the
layouts using constraints. This is an example.

1. Define a new constraint from the top of the credits to the bottom
   of its container so its vertical space is 0. Red lines appear to
   inform you that there are conflicts in the constraints.
2. Change the priority of the constraint from the top of the credits
   label to the bottom of the app name to be 749.
3. Change the priority of the constraint from the top of the credits
   to the bottom of its container to 751.
4. Create an outlet for the original constraint to the
   copyright. Call it finalVerticalConstraintCredits.
5. Create an outlet for the new constraint to the bottom of the
   container. Call it initialVerticalConstraintCredits.
6. In the initial animation block change the priority of the initial
   constraint to 745 (`UILayoutPriorityDefaultHigh - 5`).
7. Also in the initial animation block change the priority of the
   final constraint to 755 (`UILayoutPriorityDefaultHigh + 5`).
8. Run it and verify the results.
9. Change the vertical content hugging priority of the icon, the app
   name label, and the copyright label to 750 (High).
10. Run it and verify the results.
11. At the end of the animation block, make the main view of the view
    controller to layout its subviews if needed.
12. It is not required in this case, but add the same line before the
    animation block.
13. Run it and verify the results.

## Concatenate animations

In this exercise we try to animate the icon after the credits have
appeared. And we try to find a solution for when we want both
animations to overlap.

1. Inside of the completion block of the animation, create a new
   animation block.
2. Move the changes to the icon to the second animation block.
3. Run it and verify the results.
4. Change the duration of both animations to 0.3
5. Run it and verify the results.
6. Create a new animation using a keyframe animation with a duration
   of 0.5 and an empty completion block.
7. Inside of the new animation block, add two keyframes.
8. The first one should have delay 0, duration 0.5 (50%) and the constraint
   changes for the credits label.
9. The second one should have delay 0.2, duration 0.6 (60%) and the
   changes to animate the icon.
10. Remove the previous animations.
11. Run it and verify the results.

## Add fire to the icon using a particle emitter

Use a particle emiter to create an animation that looks like fire
behind the icon.

1. In the completion block of the keyframe animation, create a new
   `CAEmitterLayer`. Call it emitter.
2. Set the position of the emitter to be the center of the icon in the
   main view.
3. Set the emitterMode to be Outline, the emitterShape to be Circle,
   and the render mode to be additive.
4. Set the emitterSize to be the size of the icon.
5. Create a new `CAEmitterCell`. Call it particle.
6. For the particle, set its emissionLongitude to be pi (`M_PI`), its
   birthRate to be 30.0, its lifetime to be 0.5, its lifetimeRange to
   be 0.3.
7. Also, set its velocity to 20.0, its velocityRange to 20.0, its
   yAcceleration to -100.0, and its emissionRange to pi (`M_PI`).
8. Set its scale to 0.8, its scale range to 0.4, and its scaleSpeed =
   0.2
9. Copy the image for the fire particle and set the contents to
   CGImageRef of it.
10. Set the name of the particle to "particle".
11. Use the generated particle in an array to set the emitterCells of
    the emitter.
12. Add the emitter layer to the view layer inserting it below the
    icon image.
13. Run and see the results.
14. In order to stop the fire, we need to dispatch a block in the main
    queue after 1.5 seconds.
15. In the block set the value 0.0 for the key
    "emitterCells.particle.birthRate" of the emitter.
16. Run and verify the results.

## Implement a custom animation for the transition to the credits view controller (forward only)

Create a custom transition animation for the credits view controller
that does mostly the same as the default one.

1. In the prepareForSegue:sender: method of the
   AgentsViewController, respond to the case in where the identifier
   is the one for the segue to the credits view controller ("ShowCredits").
2. Set the transitioningDelegate of the destinationViewController to
   be this one.
3. In the header, declare implementation of the
   UIViewControllerTransitioningDelegate protocol.
4. In the implementation, write the declaration of the methods
   `animationControllerForPresentedController:presentingController:sourceController:`
   and animationControllerForDismissedController:
5. Create a new subclass of NSObject called PresenterAnimator.
6. In the header of that class declar the implementation of the
   `UIViewControllerAnimatedTransitioning` protocol.
7. In the implementation, declare the two methods that are required in the protocol.
8. Declare a static constant NSInterval and return it in
   transitionDuration method.
9. Declare a boolean property in the internal interface. Call it "forward".
10. Define a constructor that takes a BOOL parameter and sets the
    boolean property. Call it initForwardTransition: and make it public.
11. Extract the two view controllers and the two views in local variables.
12. Define two methods:
    `animateTransitionForwardWithContext:fromViewController:toViewController:fromView:toView:`
    and
    `animateTransitionBackwardWithContext:fromViewController:toViewController:fromView:toView:`
    and invoke each of them from the animate transition with the
    extracted parameters, depending on the forward property.
13. In the forward method, extract the container view, where the
    animation happens.
14. Verify that the transition context isAnimated.
15. If so, the startFrame should be the one of the containerView with
    the y origin set to the negative value of the height of this view.
16. Use that frame for the toView and add it to the final frame
    obtained from the transition context.
17. Create an animation block with a spring and animate the frame to
    the original position of the content view.
18. And in the completion block, invoke the completeTransition method
    of the transition context with YES as the parameter.
19. In the delegate method of the AgentsViewController return an
    instance of the new object with forward set to YES or NO depending
    on the method.
20. If the context is not animated, just set the frame of the toView
    to the final one and add the subview.
21. Run and verify.

## Add backward animation to the transition

Make the backwards transition be animated too.

1. Copy the contents of the forward animation to the backward animation.
2. The initial frame of the toView should be the one returned by the context.

## Animate the forward transition using snapshots and 3D

Create a more appealing animation using snapshots and three
dimentional transformations.

1. In the forward method of the previous transition set the frame of
   the toView before the conditional that checks the animation and
   remove it from the else case.
2. In the conditional, obtain the size of the fromView containter.
3. Define two frames, one that covers the top half of the view and
   another one that covers the bottom half.
4. Using the
   resizableSnapshotViewFromRect:afterScreenUpdates:withCapInsets:
   method from the view capture two snaptshots using the previously
   defined frames.
5. Add the toView to the containerView.
6. Add the two snapshot views on top of the toView with their
   respective frames.
7. In the animation block, define a CATransformation3D for a rotation
   of 90 degrees over the X axis (rotationUp) and another one for a
   rotation of -90 degrees over the same X axis.
8. Apply the former transformation to the transformation property of
   the layer of the top half view and later to the bottom half view.
9. In the completion block of the animation remove both views, top
   and bottom halves, from its superview.
10. Run and watch the results.
11. Set the anchorPoint for both views before the animation block. For
    the top one, it should be in (0.5, 0.0). For the bottom one it
    should be in (0.5, 1.0).
12. Debug to check the position of the layers before the animation block.
13. Change the position to reflect the one in the superview. The top
    one should be in (viewSize.width/2, 0.0). The bottom one, in
    (viewSize.width/2, viewSize.height).
14. Run and watch the results.
15. Add perspective to the transformations by changing their m34
    element to -1/500.
16. Run it and see the results.

## Animate the backwards transition with snapshots and 3D transforms

Make it work for the transition backwards.

1. Capture the top and bottom images of the from view.
2. Add both views on top of the from view.
3. Copy the two transformations from the animation block of the
   forward transformation and set them before the animation block.
4. In the animation block, set both transformations to the identity.
5. In the completion block add the toView to the containterView and
   remove the views with the snapshots.
6. Run and watch the results.
7. Add the toView before capturing the snapshots and remove it from
   its superview before the animation block.
8. Run and watch the results.
9. In order to have the contents of the cells captured in the
   snapshots set afterScreenUpdates to YES.
10. Run and watch the results.


## Reuse the animation for the detail view controller

This exercise demonstrates that a custom transition animation can be
reused in other applications or other parts of the same app.

1. In the prepareForSegue:sender: method move the setting of the
   transitioningDelegate from the case with identifier to the common
   part of the method.
2. Run it and see the results.
