# Introduction #

This source code is the one that I use for my Core Data and Unit
testing course.  I have used it for the Ironhack training for which I
have been responsible for teaching the Core Data and Testing (unit
testing, TDD) week and I decided to create this examples that can be
used as exercises.  Feel free to use them. And if you are interested
in more code like this, I do contract work. Contact me:
- Email: jdortiz -at- powwau.com
- Twitter: jdortiz

The core contents of the week are about the model part of an
application. In the examples I won't purposely focus on the visual
part: no autolayout constraints, no fancy animations, no problem with
poor UX.

Git is assumed. **ALWAYS** commit after each section of the exercises.
The repo has been created with that philosophy, each section
corresponds to a commit. Thus, you can checkout the version before the
exercise and compare it with the next commit to check my answer to the
exercise.

I do know that not all the answers are optimal, some will have to be
improved for performance in production code. However:

1. I am against of premature optimization.
2. I rather favor legibility than performance.
3. These examples are meant for other people to understand what is
   going on and learn from them.

# Exercises #

## Basic Core Data demo ##

Full use of Core Data the "hard way", using KVC.

### Create project (2 min) ###

Learn the basics.

1. Open Xcode
2. New project iOS -> Application -> Master-Detail Application
3. Product Name: "BadHunter", Language: "Objective-C", Devices:
   "iPhone", Select "Use Core Data"
4. Choose directory and maintain "create git repository" selected.

### Review project template contents (5 min) ###

Understand how the template works.

1. Visit BadHunter.xcdatamodeld.  This is the information about the
   model. In its initial version, it contains 1 entity (Event), 1
   attribute (timeStamp).
2. Visit Main.storyboard.  It contains the expected screens for a
   master detail application.  Notice that there are no buttons in the
   storyboard!
3. Visit MasterViewController.m:
   1. Inspect `viewDidLoad`.  Why are buttons added in code?
   2. Notice that VC and model are also coupled in the codde (Example
      `insertNewObject`.)
4. Run the app to see how it works.

### Change the model to have agent entities (10 min) ###

Use our own model with the template.

1. Edit the name of the entity in the model. Change it to Agent.
2. Delete the existing attribute.
3. Show the Data model inspector (Menu View -> Show Data Model
   Inspector)
4. Create 3 new attributes:
   1. name :: String, not optional, indexed
   2. destructionPower :: Integer 16, not optional
   3. motivation :: Integer 16, not optional
5. Run it and it will crash. Read the log to find out why.
6. In order to solve the crash, from the terminal:

        $ cd ~/Library/Developer/CoreSimulator
        $ find . -name BadHunter.sqlite
        $ find . -name BadHunter.sqlite -exec rm {} \;


### Change the query of the fetchedResultsController to use agents (3 min) ###

Make the table display the agents (for when they are ready later).

1. Run it and it will crash. The name of the entity and the attribute in
   fetchedResultsController are wrong.
2. Change the name of the entity to "Agent" and the attribute to "name"

### Modify the detail view controller to use agent objects (20 min) ###

Modify the master view controller so it creates agent objects will later allow to edit the
agent data. In this step, only the views are put in place and the
basic initialization.

1. Run it again and tap on the plus button at the top. It will crash
   because the creation still uses the attribute timeStamp. Shouldn't
   we change it once for all the code?
2. Comment out the insertNewObject method.
3. Remove the creation of the add button in viewDidLoad and comment
   out the creation of the edit button.
4. Time to edit the detail view controller to populate the fields. Use
   the storyboard to create these fields in the viewcontroller:
   1. Delete the existing label.
   2. Add one textfield for the name and configure its parameters (placeholder).
   3. Add five labels (2 fixed for the other attributes, 2 for the
      textual values, and 1 for the general appraisal.)
   4. Add two steppers.
5. In the detail view controller header, define IBOutlets for the
   three labels that will change, the text field and the two steppers.
6. Connect the outlets to their respective object in interface
   builder.
7. Initialize the values of the labels in viewDidLoad. Use arrays for the
   named values of the 3 properties of the agent object.
8. Build without errors.

### Prepare the detail view controllers for creating agents (15 min) ###

Have a segue that works to enable editing newly created agents.

1. Delete the existing segue that connects master and detail view
   controllers.
2. Embed the detail view controller in a navigation controller.
3. Add a new "+" button to the master view controller.
4. Create a segue presented modally from the button to the detail view
   controller and name it "CreateAgent".
5. In the detail view controller header, change the name of the
   property from `detailItem` to `agent`.
6. Modify the metod `prepareForSegue` of the master view controller:
   1. Define a constant string for the class with the name of the
      segue.
   2. Extract the destination view controller from the segue.
   3. Create a new agent object. Use the commented method
      `insertNewObject:` as a reference.
   4. Pass the new agent to the detail view controller.
7. Run and test. Notice there is no way to go back to the master view controller.

### Add actions to the detail view controller (20 min) ###

Respond to the events of the interface in the view controller used for
editing that make the user go back to the main view controller.

1. Add new header file with the protocol to dismiss the view
   controller. (1 method, 1 boolean parameter: modifiedData)
2. In the detail, import the new header and define a delegate property.
3. Make the header of the master implement the protocol.
4. Assign the delegate in the prepareForSegue of the master.
5. Implement the method in the master that dismisses the view
   controller. (No data saving yet.)
6. Define the two actions for each bar button in the detail view
   controller. Each one uses the protocol method.
7. In the storyboard create two bar buttons to cancel and save the
   contents of the detail view controller.
8. Connnect them with their respective actions.
9. Run it and it will throw an error. Change the attribute name of the
   configureCell method to "name".

### Create actions for the controls of the detail view controller (10 min) ###

Define actions to respond to the events generated by the steppers and
use that data  and the name with the object.

1. Inside of the save action include a method to read the value from
   the text field and apply it to the agent object.
2. Define a new method to deal with changes of the destruction power
   and apply those changes to the destruction power attribute.
3. Connect the method to stepper for the destruction value.
4. Run and verify that the labels aren't updated.
5. Create the analogous method for the motivation stepper and connect it.

### Show the updated values of the agent object in the view controller (10 min) ###

Update the labels of interface when the values change. This is done by
pushing the changes.

1. Add a method for each label to display its value based on the
   respective agent property.
2. Invoke the required methods in each of the stepper actions.
3. Refactor viewDidLoad using the new methods.
4. Run and verify that the labels are updated.
5. Verify that the steppers only change within the expected range or
   solve in Interface Builder.

### Persist the data (15 min) ###

Use the undo manager to forget about objects that the user decides
cancelling their creation. Save the context to make the (not-undone)
changes persistent (in the file system).

1. Review the app delegate, the section of the Core Data Stack.
2. Create an undo manager and assign it to the moc. Configure it to
   not create groups by event and limit the number of undos to 10.
3. Begin an undo group before creating the new object in the master
   view controller.
4. Set the action name for the undo operation and end the undo group
   in the method that is used to dismiss the detail view controller.
5. If modified data should be preserved, call the save method of the context.
6. If modified data should be dismissed, rollback the change.

### Janitorial changes (5 min) ###

Cleaner code.

1. Remove commented out code.
2. Rename the detail view controller to AgentEditViewController using
   the refactoring capabilities of Xcode.
3. Rename the Master view controller to AgentsViewController.
4. Change the object update case of the FRC delegate to reload the
   row instead of reconfiguring.

## Subclassing the managed object ##

This is the way Core Data is commonly used. Objective-C objects are
mapped to the database with their properties and methods.

### Create Agent as a subclass of MO (10 min) ###

Have the class ready to be able to use it in the rest of the
code. From now on, use properties instead of KVC to access the
attributes of the object.

1. Use Xcode to generate the subclass.
2. Review the generated subclass.
3. Replace the code to use the properties in the Agents view controller.
   1. Import the Agent.h header
   2. Change configureCell.
   3. Change the type of the object created in your prepare for segue
      method.
4. Replace the code to use the properties in the Agent edit view controller.
   1. Change its header so the agent type is Agent * using a forward
      declaration.
   2. Import the Agent.h header in the implementation file.
   3. Replace all the invocation to setValue:forKey: and valueForKey:
      by the corresponding properties.

### Observe chages to the agent properties (15 min) ###

Be able to react to changes in the model instead of pushing them from
the events.

1. Remove the call to the method that updates the label of the
   destruction power from the action assigned to its stepper. Don't
   stop updating the appraisal label.
2. Add the view controller as an observer for the keypath
   agent.destructionPower in viewWillAppear (no options, no context.)
3. Remove the observer in viewDidDisappear
4. Write the method to respond to the value changes so it updates the
   text of the label.
5. Run and test that the label is updated.
6. Repeat the same sequence for the motivation attribute.

### Move appraisal logic to the model (20 min) ###

Understand the value provided by transient properties. Have properties
that depend on other properties.

The way to calculate assessment is part of the model. However, it is
outside of the model itself. Move that to the model and make it change
when the other properties change.

1. Create a new attribute in the model: appraisal: int16, transient,
   non optional.
2. Chech Agent.h and Agent.m. Nothing has changed, they must be
   regenerated. Do so.
3. Create the getter for it in the implementation file that uses the
   equation to calculate the appraisal and returns it.
4. Add the access notifications in the getter so it is observable. Use
   calls to will/didAccessValueForKey:
5. Use it in the method to display the appraisal.
6. Remove the call to the method that updates the label of the
   appraisal from the actions assigned to both steppers.
7. Add an observer for its keypath. Run and check that it doesn't work.
8. Create custom setters for the motivation and the destruction power
   that notify that the value of assessment changes when they change.

### Add more properties and make dependencies in categories easier (20 min) ###

Understand how the custom setters and getters in Core Data and how to
define dependencies in a category.

1. Notify of the dependencies affecting appraisal with the class
   method keyPathsForValuesAffectingValueForKey: Remember to call
   super first.
2. Remove the custom setters of the other two properties.
3. Run and verify that dependencies work.
4. Create a new string attribute called pictureURL (optional, not indexed).
5. Regenerate the subclass.
6. Verify the regenerated files and notice what is missing.
7. Create a "Model" category of the agent class.
8. Recover the model logic code from the previous git commit and put
   it in the Model category.
9. Run it. It will crash. Remove the database.
10. Run it again and test the model logic. WARNING: the results here
    MAY vary.
11. Tell Core Data that the value of appraisal depends on the other
    two attributes using the custom class method
    `(NSSet *)keyPathsForValuesAffectingAppraisal`.
12. Run and test the dependency
13. Create constant strings for the properties in the category
    implementation and declare them as extern in the header.

### Add agent editing capabilities (20 min) ###

Make the interface easier to use, and the created objects editable
using a second segue to the same view controllers.

1. In the agent edit view controller header declare that it implements
   the protocol to be a text field delegate.
2. Add the delegate method alows the keyboard to be dismissed.
3. And connect the view controller to the text field as delegate.
4. Create another segue from the agents view controller to the
   navigation controller connected to the agent edit with the
   identifier "EditAgent", in order to visit and edit exisiting agent
   objects when they are selected from the table.
5. Refactor the prepare for segue so it covers both cases. Remember
   to have different names fro the two undo actions.
6. Change the agent edit view controller so:
   1. Uses the agent category header.
   2. It shows the name of the agent being edited.
   3. Initializes the steppers with the current values.

### Use primitive values for the transient property (5 min) ###

If the process to obtain the value of the transient property is
complex or lengthy, the result can be cached.

1. Extract the appraisal calculation to a separate method.
2. Modify the getter for the appraisal so it is cached in a primitive
   value. If the primitive value doesn't exist yet, genereate it with
   the method to calculate the appraisal.
3. Generate custom setters for the destruction power and motivation,
   so they also update the value of the appraisal and store it in its
   primitive value.

### Assign and view the picture (1:30h) ###

Have the user interface required to select/edit/delete images.

1. Move all the controls of the agent edit view controller downwards
   to leave space for the picure.
2. Create a 100x100 button with the label "Add image"
3. Create an action in the view controller that shows an action sheet
   (Take photo, Select photo, Delete photo).
4. Make the view controller and action sheet delegate and add the
   method that responds to the action sheet options.
5. Use UIImagePickerVC to obtain the images from the user.
6. Persistence of the images must be a separated object (SRP).

## Relationships and Predicates ##

Having the data inside of the database is important, but it is even
more important to be able to extract the data that we want from it.

### Move the query to the model (15min) ###

Queries are part of the model, so they belong there.

1. In the agent category, create a constant string with the name of
   the entity.
2. Add a class method to the Agent category that provides the fetch
   request used by the fetch results controller of the agents view
   controller.
3. Try it with fetched results controller. Verify the order.
4. Create a similar request with a predicate as a parameter. Use it to
   filter out the agents with a destruction power smaller than 2.
5. Try it and it will crash. Find out why from the log and solve it.

### Create relationships (10 min) ###

Relationships is one of the most powerful features of Core Data. Let's
modify the model to be able to use them.

1. Define 2 new entities:
   1. "FreakType": with attribute "name": string, non optional,
      indexed and relationship "agents", optional, cardinality: 1
      category includes many agents, delete rule: cascade. Reverse
      relationship "category", optional, delete rule, nullify,
      cardinality 1 agent belongs to 1 category.
   2. "Domain": with atribute "name": string, non optional, indexed
      and relationship "agents", optional, cardinality 1 domain has
      many agents, delete rule: deny. Reverse relationship "domains",
      1 agent works in many domains, delete rule: nulify.
2. Regenerate the subclasses (all three). And delete the database,
   once again.

### Create controls to edit the category and domains (30 min) ###

Modify the user interface to be able to use the relationships.

1. Add two text fields besides the picture.
2. Add two iboutlets for them in the agent edit view controller
   header, connect them and set the view controller as delegate.
3. Create a method that, when the text field has finished being
   edited, parses the string (spliting by commas for the domains, and
   nothing for the category) and creates an attributed string decides
   with green colors for objects that already exist, and red for the
   ones that don't. The implementation of whether they exist or not
   will be done later.

### Work with relationships (20 min) ###

Add logic to the FreakType and Domain entities that will make working
with relationships easier. Use them in the agent edit view controller.

1. Change the fetch request of the FRC back to the one that gets all
   the agents.
2. Create a convenience constructor for the FreakType that uses a name.
3. Create a class method that returns the FreakType with the provided
   name in the given managed object context.
4. Use those two methods when saving the agent.
5. Create the analogous methods for the domains. Keep in mind that the
   relationship with the domains is expressed using a NSSet.
6. Uncomment the methods used to colorize the data in the text fields.

### Add different possibilities for sorting the agents list (10 min) ###

Demonstrate different ways to sort the data. Understand the
limitations of transient attributes.

1. Create a new method of the Agent, that generates a fetch request
   sorted with the provided sort descriptors.
2. Create a sort descriptor to sort by destruction power. Run it and
   see the results.
3. Use the same method sorting by assesment. Run it and see what happens.
4. You can also sort by more than one criteria. Try sorting by
   destruction power and then by name.

### Use sections in the table (5 min) ###

Use relationship based sections in the table view.

1. Modify the fetch results controller to use the category name as section.
2. Add the table view data source method to return the name of the
   section from the corresponding object of the sections array in the
   fetched results controller.
3. Complete the section header title with the average of the
   destruction power of the members of that section.

### Add a complex query for the domains (5 min) ###

Use a subquery to get advanced information.

1. Create a fetch request of the domains that returns those which
   have more than one agent with a destruction power of 3 or more.
2. Calculate the number of results and display it in the title.
3. Refresh it after controller did finish.

### Exercises for the reader (15 min) ###

- Complete the CRUD. Delete an object when the user swipes over one of the table rows.

## Unit testing demo: Testing the app delegate ##

Install the test Template.

### Test return value: Sut not nil ###

Understand how to test a method for a return value.

1. Delete existing unit test file.
2. Under the BadHunterTests folder create an "AppDelegate" group.
3. Create the Test class for the app delegate.
4. Remove from it all the Core Data related code.
5. Validate the "sut is not nil" test.

### Test state: managedObjectContext ###

Understand how to test a method that changes the state of the object.

1. Check that the managed object context is created when accessed.

### Test behavior: saving the data of a managed object context ###

Understand how to test a method that uses other objects.

1. Add a test to check that the `saveContext` method tells the
   `managedObjectContext` to save the changes.
2. Create a subclass of MOC in the same file (mocFake).
3. Create an instance of that class in the test and inject it into the
   sut using kvc.
4. Override the ~hasChanges~ method to return YES.
5. Create a BOOL property to record the changes.
6. Set the property to YES in the overriden save: method.
7. Verify that it is yes.

### Exercises for the reader (30 - 45 min) ###

- Test app documents directory is not nil, is a directory (not a
  file), contains Documents as the last component of the path...
- Test the managed object model and the persistent store coordinator
  are created when the managed object context is accessed.
- Test the root view controller is assigned the managed object context
  on launch.

## Testing Core Data ##

### Basic test of a model class (10 min) ###

1. Create a unit test for the agent with the provided template, inside
   of a new "Model" group.
2. Run and verify that it fails, because the object isn't created
   properly.
3. Uncomment and verify the creation and release of the Core Data stack.
4. Use Agent+Model.h instead of just Agent.h when importing into the
   test file.
5. Make the entity name shared.
6. Change the createSut method to create an agent ala Core Data.
7. Run and verify that it fails.
8. Include the model in the unit test target.
9. Run and verify that it works.

## Versioning & migration ##

Understand how to change the model in a controller way. Be sure to
have some data loaded (at least 3 agents for the examples).

### Identifying the current model version (5 min) ###

Understand the current status of the model.

1. Run the program to check that it runs and displays the current data.
2. In the file inspector of the model fill in a new version
   identifier (1.0.0).
3. Run the program again to see that nothing has changed.
4. Using the terminal, go to the directory where the sqlite of the
   project is. Execute the following command and keep what follows
   NSStoreModelVersionHashesVersion resulting from the last one.

        $ sqlite3 BadHunter.sqlite
        > select * from sqlite_master where type='table';
        > select * from Z_METADATA;
        > .quit

### Adding a new model version (10 min) ###

Create a the new version of the model.

1. Add a new model version (Editor -> Add Model Version...)
2. Name it "BadHunter 1.1.0"
3. **In the new model**, add a new attribute to the Agent entity (Power:
   string, optional, not indexed.)
4. Edit the model version identifier of the new one to have the right one.
5. Run and it will not crash.
6. Check the hash and see that it is still the same.
7. In the inspector of the model change the current model version to
   the new one.
8. Run and it will crash. The value of
   `NSStoreModelVersionHashesVersion` will continue being the same.

### Lightweight migration (5 min) ###

Let Core Data take care of the required changes to the data based on
the new model.

1. In the persistentCoordinator getter of the app delegate, create a
   new dicionary for the options to use with the persistent store.
2. Add options to make automatic migration of the store and infer the
   mapping automatically and pass them to the persistent store
   addition process.
3. Run it. It will not crash, but we haven't made any change to the
   interface to know that the change has actually happened.

### Verifying the change (5 min) ###

Check that the expected change has happened.

1. Add a breakpoint to any method that uses an Agent object. For
   example AgentsViewController's configureCell:atIndexPath:.
2. Run 'po agent' in the debugger and verify that power is one of the
   attributes.
3. In the terminal chech that the string after
   `NSStoreModelVersionHashesVersion` has finally changed. The store
   has been migrated.

### Populate data to preserve (10 min) ###

Prepare data for the next, more complex, migration.

1. Regenerate the Agent subclass.
2. In order to have some data add line in the `prepareForSegue` part
   of the edit view controller to set the power to Intelligence if the
   row is an even number or Strength if it is odd.
3. Run it visit some (not all) of the agents and remember to save them.
4. Use the debuger to print the fetchedObjects of the
   fetchedResultsController to verify that the data has been created.
5. Close the application by quiting it from the simulator (task
   manager) and query the sqlite database to double-check that the
   data is there.
6. Preserve a copy of the current database. Query that copy to ensure
   that the data is there. (MD5s appreciated).

### A new model with complex changes (15 min) ###

Now our goal is to be able to have many powers per agent (a many to
many relationship). Create the model for it.

1. Add a new model based on BadHunter 1.1.0 and call it "BadHunter 2.0.0".
2. Edit its identifier.
3. Create a new entity Power with one attribute name: string, non
   optional, indexed.
4. Create a to-many relationship in Agents: powers, and the inverse
   relationship in Power, agents that is also to-many.
5. Remove the power attribute of the Agent entity.
6. Remove the line that was inserted to assign a power based on the
   row number.
7. Regenerate the Agent and Power entities.
8. Create a Model category of the Power class.
9. Create a class method in Power to fetch a power with a given name
   in a given MOC.
10. Build it, but **DON'T run the app** or else it will loose the
    data, because lightweight migration is enabled. (if you make 2 the
    current version).

### Create the mapping (20 min) ###

Provide the required information to preserve the names of the existing
powers into the new entities, without duplicating them.

1. Create a new file, Mapping Model, from version 1.1.0 to 2.0.0.
2. Inspect (but don't change) the newly created mapping.
3. In the `AgentToAgent` entity mapping notice that there is the
   posibility to create a custom policy.
4. Create subclass of `NSEntityMigrationPolicy` and call it
   `AgentToAgentMigrationPolicy`.
5. Override the method
   `createDestinationInstancesForSourceInstance:entityMapping:manager:error:`
   It must do 4 things:
   1. Create the destination instance (an Agent in the destination
      context).
   2. Transfer the **attributes** from the source to the destination
      one.
   3. Extract a pawer instance with the name of the attribute (or use
      the already existing one) and relate it with the destination instance.
   4. Tell the migration manager to associate the source and
      destination instances.
6. Remember to return YES from that method.
7. Use this class as the name of the custom policy for the Agents mapping.
8. Make version 2 the current version of the model.
9. Run and check with the debugger that the relationships exists. For
   any object that had a power in the previous dataset,
   `po [[agent.powers anyObject] name]`

## System concurrency ##

### Create an authenication token (20 min) ###

Prevent editing or viewing details from stolen devices.

1. To disable the segue if the user isn't authenticated yet, delete
   the segue from the row of the agents view controller in the storyboard,
2. Create a new segue from the Agents view controller (not the row) to
   the navigation controller of the agent edit view controller. Use
   the same identifier "EditAgent" that you used before.
3. Implement the method `tableView:didSelectRowAtIndexPath` and
   invoke `performSegueWithIdentifier:sender:` from there.
4. Run the app and verify that the segue works as before the change.
5. Add a condition in that method to avoid performing the segue if the
   device isn't verified. You need a property for holding that
   information, that should be initialized to NO. In case the
   condition is not fulfilled, deselect the row.
6. Finally add a verification method that:
   1. Prints a message to NSLog.
   2. Sleeps for 10 seconds (using NSThread class method).
   3. And changes the property that clears the device as verified.
7. Add a button to the left of the navigation bar using the "Stop
   identifier".
8. Create an outlet for that button.
9. Add an observer for the property that holds the verification
   status that changes the type of the button and its tint to
   green. Remember to remove the observer when done.
10. Run it an notice that the main controller waits to be loaded
    until the verification ends and the button is green from the
    moment is loaded.

### Implement concurrency with Operation Queues (10 min) ###

Implement an operation that is schedulled immediatelly in another
thread.

1. Remove the call to the method that verifies the device from the
   `viewDidLoad`.
2. Create a new method that launches the verification in the
   background that:
   1. Creates an instance of `NSInvocationOperation` with the view
      controller method to verify the device and no object as
      parameter.
   2. Creates a queue and gives a name to it.
   3. Adds the operation to the queue.
3. Run this new version an notice that the app starts immediatelly,
   and the verification is passed after 30m seconds.
4. Put a breakpoint before creating the queue. Run it until it stops,
   continue and pause as fast as you can (you have 30 seconds).
5. Inspect the name of the threads and their queues.

### Implement concurrency with GCD and blocks (10 min) ###

Implement the verification in a block avoiding memory leaks.

1. In the method that was creating the operation and the operation
   queue, obtain a global concurrent queue with default priority. Use
   `dispatch_async` to schedule the verification process in that
   queue.
2. Move the three steps of the verification process to the block
   (NSLog, sleep, set property).
3. This should work, but there is a better method to create the block
   so it avoids having memory leaks.
   1. Create a `__weak` variable of to hold a weak copy of self. Call
      it weakSelf.
   2. In order to ensure that this is executed even if the owner is
      deallocated, make a strong copy of the weakSelf and use it to
      access the property.

## Core Data Concurrency

We are going to import 10.000 agents everytime the application
runs. This will happen in the app delegate.

### Create a fake importer (15 min) ###

Create a method in the app delegate that simulates loading 10.000
registers taking 5 seconds to complete.

1. Add a convenience constructor for the Agent with a given name.
2. Define a fake importer method in the app delegate that does:
   1. Create a category with its convenience constructor (any name).
   2. Create 10.000 registers with different names using the
      convenience constructor.
   3. Relate the object and the category.
   4. Wait using usleep after each agent creation, so the total time
      is aprox. 5 secs.
   5. When all the objects have been created, save the changes.
3. Invoke the method when the app has just finished launching, before
   anything else.
4. Run the program and see what happens.
5. Remove the database from the application directory.

### Plan the task for a better moment (10 min) ###

Plan the  task asynchornously in the same context / main thread.

1. Change the importer method so all the action happens inside of a
   block that is passed for asynchronous execution to the MOC.
2. Remember to weakfy and strongfy self.
3. Change the initialization of the main managed object context so
   its concurrency type is `NSMainQueueConcurrencyType`
4. Run the application an see if anything changes.
5. Remove the database from the application directory.

### Make a better importer (5 min) ###

Prepare the method to change the MOC.

1. Change the importer method so it takes a managed object context as
   parameter.
2. Use the parameter instead of the property in all the required
   places.
Comment:
- It should be easier than the previous versions and less leaks.

### Create an independent background context (20 min) ###

Have a different context to perform the time consuming process in a
background queue. The database must be empty at the beginning of this
section. It is necessary to add some logic to make the main context
know about the changes.

1. Define another property for the backgroundMOC.
2. Write a lazy instantiation method for this property that creates
   this context with concurrency type private queue.
3. Remember to set the persistent coordinator of this context to the
   existing one.
4. Change the context used as parameter for the importer method to
   the background one.
6. Run the app and wait for 15 seconds. Why doesn't it appear?
7. Use `sqlite3` to query the database to check if the data has been
   imported in saved.
8. Stop the app and delete the database.

### Making the main context aware of the changes in the background context (10 min) ###

Receive the notifications produced by the background context when
it saves the changes to merge them.

1. Right after the application ends launching, register to attend to
   the NSManagedObjectContextDidSaveNotification
2. Create to the method that will handle the notification. It should
   accept just one NSNotification* parameter, and invoke the method of
   the main MOC that takes the notification and merges the changes.
3. Remember to deregister for receiving notifications in
   applicationWillTerminate.
4. Run the application an see if the data is shown.
5. Stop the app and delete the database.

### Creating the three layer nested contexts stack (30 min) ###

Use nested context to have the parent updated automatically.

1. Add a third MOC property and call it rootMOC.
2. Synthesize the property.
3. Make a copy of the backgroundMOC getter and rename it
   rootMOC (and the ivars used inside must be _rootMOC.)
4. The managedObjectContext (also known as mainMOC.) getter needs to
   do the following things:
   1. Perform lazy instanciation.
   2. Instanciate the MOC with concurrency type Main.
   3. Become the child of the rootMOC
   4. Assign the undoManager to it.
   5. And return that value.
5. The rootMOC getter needs to do the following things:
   1. Perform lazy instanciation.
   2. Verify the persistent coordinator exists.
   3. If it does, instanciate the MOC with concurrency type Private Queue.
   4. Assign the persistence coordinator to its property.
   5. And return that value.
6. The backgroundMOC is much easier now:
   1. Performs lazy instantiation.
   2. Instanciates it with private queue concurrency type.
   3. Become the child of the managedObjectContext (or mainMOC)
7. Remove the registration and deregistration for the notification of
   the MOC changes and the method for that.
8. Run the app and wait until the objects appear on the table view.
9. Check the contents of the database.
10. Stop and delete the database.

### Use UIManagedDocument subclass to simplify the concurrency model (20 min) ###

Use Apple's provided class that creates the stack for us.

1. Create a subclass of UIManagedDocument called Model.
2. Create a new property in the app delegate of that class Managed
   called model.
3. Initialize the model lazily, not using the URL that was previously
   used for the persistent store.
4. Move the importer method from the app delegate to the
   Model class.
5. Create a public method that creates a background method and uses
   the importer method.
6. Create a method to initalize the model in the app delegate. If the
   file exists, open it, otherwise, create it.
7. Modify the agents view controller so it takes a Model instance,
   instead of the managedObjectContext.
8. Replace the references to the MOC in the view controller to the
   MOC of the model.
9. Add a notificationCenter property to the agents view controller
   with lazy instanciation.
10. Register an observer in the notification center to recive
    UIDocumentStatusChanged notification and call modelStatusChanged.
11. The method modelStatusChanged should reset the FRC and reload the
    table.
12. Finally, remove all the references to Core Data from the
    application delegate (but the Model).
13. Run an check how easy it is to have a concurrent Core Data application.
