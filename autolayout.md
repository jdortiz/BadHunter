# Autolayout

## Add a credits view controller

Let's start with a new view controller that we can work with.

1. Open the project and go to the Storyboard.
2. Add a new view controller for the credits.
3. Add a navigation bar button to the left of the navigation bar of
   the AgentsViewController.
4. Change its label to credits.
5. Connect the button with the credits view controller. Use a *Present
   modally* segue and call it "ShowCredits".
6. Add an image (make it rectangular), four labels and a button to the
   credits view controller.
7. Copy the logo images to the assets folder, by dragging and dropping
   the images into the already opened assets folder.
8. Set the image to use the logo. 9. Set the text of one of the labels
   to the application name ("BadHunter"), another one to the version
   number ("v.1.0"), the third one to the copyright notice ("(c)
   Copyright MaloSA, 2015"), and the fourth one to the credits:
   "Special thanks to: Gru, Kingpin, Godzilla, Alien, Dr. Octopus,
   King Kong, Predator, el Macho, and Randall Boggs and many others
   that I forgot to mention."
10. Set the text of the button to "OK".
11. Set the fonts for the labels: bold for the app name, 12pt for the
    copyright, and default attributes for the version number and the
    credits.
12. Run it an see the results.

## Unwind segue

This is not exactly about autolayout, but is the way
to go. Unwind segues have been available since iOS6.

1. Create a method in AgentsViewController with the signature:

        -(IBAction)dismissCredits:(UIStoryboardSegue *)segue;

2. Connect the OK button with the Exit connector on the top of the
   credits view controller and select the dismissCredit method.
3. Run it and verify that the view controller can be dismissed.

## Set initial constraints

Create a working set of constraints.

1. Select the icon.
2. Add one constraint to set the horizontal center to the center of
   the container.
3. Add another constraint to set the distance to the top to be the
   stardard value, keep the "Constrain to margins" selected.
4. Run it and notice that the image is squared. The rest of the views
   are misplaced.
5. Set the vertical distance of the app name to the icon to 20.
6. Set the the leading space to the container to 0 (with margin).
7. Set the baseline of the version number to be the same one as the
   app name.
8. Set the trailing distance to the container to 0 (with margin).
9. Align the copyright notice to the horizontal center of the container.
10. Set its top distance to the app name to be 20.
11. Set the leading space of the credits to 0 (with margin)
12. Set the top space to the copyright to 20
13. Align the button to the horizontal center of the container.
14. Set its top distance to the credits notice to be 250.
15. Update the frames of all the views. It is ok if, _for now_ the OK
    button is a little bit outside of the view controller.
16. Run it on the iPhone 6 simulator and check the results.

## Set better constraints

Solve some of the limitations of the previous set of constraints.

1. Set the trailing space of the credits to 0 (with margin).
2. Run it and see that the content of the credits gets truncated.
3. Set the number of lines of the label to 0.
4. Add previews at least for 3.5 in, 4 in, and 4.7 in. Notice that the
   button is not visible for anything smaller than 5.5 in.
5. Remove the contraint of the button that sets the vertical space
   with the credits.
6. Constraint button verticaly with space to bottom set to 0 (with
   margin). Notice that it is now visible in all the sizes.
7. Change the credits to: "Special thanks to: Darth Vader, The Kurgan,
   Terminator, Freddy Krueger, Dr. Hannibal Lecter, Norman Bates,
   Dracula, the Jocker, Lord Voldemort, Jack Torrance, Pinhead,
   Imhotep, Saruman, Ghostface, Chucky, Emperor Palpatine, Agent
   Smith, Gru, Kinkgpin, Godzilla, Alien, Dr. Octopus, King Kong,
   Predator, el Macho, and Randall Boggs and many others that I forgot
   to mention."
8. Check what happens with the credits and the button in the preview
   for the 3.5 and 4 inches devices.
9. In order to avoid this from happening, set the vertical space
   from the button to the credits lable to be greater or equal than
   the standard value.

## Use size classes for rotations

In this exercise we take advantage fo the capabilities to create a
responsive interface that adapts itself to the sizes of the different
devices.

1. Rotate the previews and see what happens with the layout.
2. Select the compact x compact class size.
3. Select the icon and select its constraint to be centered horizontally.
4. At the bottom of the constraint information there is a "+" sign an
   a check mark with the "Installed" message. Click on the plus method
   and create one for "Compact Width | Compact Height
   (current)". Uncheck the installed option for this size.
5. Set a new constraint for it that sets the leading space to its
   container to 0 (with margin). Notice that is only installed for the
   current size class.
6. Check how this changes the rotated version for the iPhone, but the
   portrait version stays the same.
7. Uninstall the leading space and the top space constraints from the
   app name for the w:compact|h:compact size class.
8. Create a new one to align the top of the app name with the top of
   the icon.
9. Create another one to set the leading space from the app name to
   the icon to be the standard value.
10. Keep the constraints of the version number and update its frame.
11. Uninstall the align center x and top space constraints of the copyright.
12. Create two new constraints for this size class one that aligns the
    vertical center of the copyright with the center of the icon and
    another one that sets the horizontal space with the icon to the
    standard value.
13. Finally uninstall the top space constraint of the credits and
    replace it with a new one for this size class referred to the
    bottom of the icon with standard value.
14. Run it in the iPhone 4s simulator and see the results.
15. Rotate with slow animations to see how views are moved.

## Adjust priorities for compression resistance and content hugging

This exercise teaches the importance of priorities in the layouts.

1. Notice that either the copyright or the OK button (it depends) is
   not shown properly in portrait mode in the 3.5in device.
2. Increase the "Content compression resistance priority" to 752 for
   the app name, copyright, and button and to 751 for the credits.
3. Check in the preview that the height of the icon is smaller.
4. Select the icon and add a constraint to maintain its aspect ratio.
5. Check the result in the previews.
6. Set the background of the app name and the version number to the
   same red of the icon and the text color to a bright gray.
7. In the any | any size class add a new constraint that sets
   the horizontal spacing between the app name and the version number
   to the standard value.
8. If you want to be sure that the width of the version number is just
   the one that is just enough to hold its data, change the content
   hugging priority of the version number to 252.
9. Run and check the results.

## Add constraints for dynamic text

Dynamic type must be taken into account in the constraints so the
layout works properly.

1. Change the size of the font to the min and max sizes and check the
   effects of that in the credits view controller.
2. Set the font of the credits label, version number, and the button to "Body".
3. Set the font of the copyright label to "footnote".
4. Set the font of the appname to "headline".
5. Run again and check the results.
6. Modify the compression resistance of the app name, copyright, and
   button to be 752 and of the credits label to be 751.
7. Rerun and see the results. Notice that the icon disappears when the
   size of the text is huge.
8. Create two new constraints for the width and the height of the
   icon, so they are greater or equal to 50.
9. Run again and check how this fixes the problem.

## Use scroll view for long forms

This is one of the typical problems that developers face when
developing an app: More content that you can fit into a
screen. Particularly if we take into account every type of screen.

1. Take a look at the current disposition of the views in the
   AgentEditViewController.
2. Select them all the subviews of AgentEditViewController.
3. From the menu, select Editor -> Embed in -> Scroll View. Notice all
   the constraints have disappeared.
4. Add constraints to the scroll view so it attaches to the bottom of
   the navigation bar and the edges of its container view on the left,
   right, and bottom.
5. Set the constraints for all the views so it looks similar to what
   it did before.
6. Ensure that there are constraints from one edge to the oposite one,
   both for the vertical and horizontal axis.
7. Run it an check that the keyboard still hides the content when
   shown.

## Change the scroll view content inset when keyboard is shown or hidden

The scroll must adapt itself to the appearance/disappearance of the
keyboard, so all the content is available always.

1. Create an outlet to the scroll view.
2. In viewWillAppear, add two observers in notification center for
   `UIKeyboardDidShowNotification` and `UIKeyboardWillHideNotification`.
3. In `viewDidDisappear`, remove the observers.
4. In the method for when the keyboard is shown, change the inset of
   the scrollview, to have the size of the keyboard (extracted from
   the notification) at the bottom.
5. In the method for when the keyboard is hidden, change the inset of
   the scrollview to 0.

## Define a custom cell layout

This is also a very common challenge for most developers. Apple has
been improving this over the years. Here we are going to practice the
solution for iOS8.

1. Modify the prototype cell for the agents to be custom.
2. Change its height to be 88 points and thend disable the custom checkmark.
3. Drag and drop into the cell one image view and 3 labels.
4. Set the constraints for the image so it respects the margins and
   its size is 40x40 points.
5. The label for the name should be aligned to the top of the image
   and the leading space set to the standard value.
6. The label for the appraisal should be aligned with the name by the
   baseline and the trailing space to the edge should be 0 (with margin).
7. The label for the fake description should be aligned to both edges
   and the bottom, respecting the margins and use the standard value
   as vertical space to the image.
8. Set the font of the agent name to be Headline and the font of the
   assessment, subhead.
9. The font of the description must be Body.

## Create a custom class for the cell

This is the key part of the process for getting cells with dynamic heights.

1. Create a custom table view cell ("AgentTableViewCell").
2. Use it as the class of the prototype.
3. Create outlets in the private interface for the 4 elements of the cell.
4. Create methods that set this elements to the expected value.
5. Change the data source methods in AgentsViewController to use that cell.
6. Use random texts for each cell description. You can have 3 and use
   them based on the integer reminder of the row number divided by 3.
7. In `viewDidLoad` change the `rowHeight` of the tableView to
   `UITableViewAutomaticDimension` and estimatedRowHeight to 88.
8. In the storyboard change the number of lines of the description
   label to 0.
9. Run and verify that you get cells with different heights.
