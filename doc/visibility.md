[< back to README](https://github.com/truefootprint/field-backend#readme)

## Visibility

The [Visibility model](https://github.com/truefootprint/field-backend/blob/master/app/models/visibility.rb)
determines which users can see which projects, project activities and project
questions. It is a kind of authorization. Visibility can be set for users
directly or for project roles which are associated to users.

When a user has visibility of a project, that project will appear in the
FieldApp when logged in as that user. The same goes for project activities and
project questions. This flexibility is needed so that different users on the
same project can answer different sets of questions.

Visibility does not propagate. For example, if a user has visibility of a
project activity, they do not automatically get visibility of the project. An
explicit visibility record must be created for the project. Also, users who are
registered for project roles do not automatically get visibility of that project.

The [DefaultVisibility](https://github.com/truefootprint/field-backend/blob/master/app/models/default_visibility.rb)
model can be used to configure which visibility records should be created by
default when projects / activities / questions are created through the
[Template](https://github.com/truefootprint/field-backend/blob/master/app/services/template.rb)
service. See the
["Templating"](https://github.com/truefootprint/field-backend/blob/master/doc/domain_model.md#templating)
section of the Domain model for more information. You will almost always want
to create default visibility of the project for each project role.

When a user makes a request to the backend, the
[ApplicationController](https://github.com/truefootprint/field-backend/blob/master/app/controllers/application_controller.rb)
sets the `Viewpoint` for the user. Records are then filtered by this using the
`visible` and `visible_to` scopes in the models, e.g. ProjectQuestion.

### Scenario: Follow-up activities

To demonstrate how visibility might be configured, let's consider a scenario
that uses follow-up activities. In this scenario, there is a 'farming workshop'
activity that farmers can attend. The trainer is asked a set of questions about
the workshop, e.g. "Did you have all the materials you needed?". The trainer
then visits each attendees farm and answers questions about whether they are
applying 'best practices' according to the workshop.

Here's how you might set up visibiltiy for this scenario:

1. You'd create a project: 'Training workshops about farming'
2. You'd create a project activity: 'Training workshop at ... on 05/06/20'
3. You'd create two project roles: 'trainer' and 'farmer'
4. You'd grant visibility of the project and project activity to the 'trainer' project role
5. You'd create an (abstract) activity: '%{farmer} applying best practices'
6. You'd create default questions for the activity: 'How much water is being used?'
7. You'd create default visibility of the activity for the 'trainer' (abstract) role
8. You'd make the activity a follow-up of the training workshop's activity

Now the trainer can log into the FieldApp and answer questions about the
workshop. Farmers can register their attendance of the workshop by calling the
`/my_registrations` endpoint. Once they do, a project activity is created by
the [Template](https://github.com/truefootprint/field-backend/blob/master/app/services/template.rb)
service that relates to the farmer and it is made visible to the trainer.
The farmer's name is interpolated into the project activity through the
[Interpolation](https://github.com/truefootprint/field-backend/blob/master/app/services/interpolation.rb)
service. The trainer can then answer questions about the farm of attendee of
the workshop.

You might also want to ask the attendees questions about either the training
workshop activity or the follow-up activity of the trainer visiting their farm.
You could do this by creating additional project questions for those activities
that are visibile to the specific user. Again, you could use 'default questions'
for this. If you granted visibility for the project role instead of the user,
the entire group of attendees would be able to answer questions about every
other attendee's farm, which probably isn't what we'd want.

If we don't ask the farmers any questions at all, there's no need for the
'farmer' project role to have visibility of the project.

This is a fairly complicated scenario but hopefully it shows how visibility can
be used in a flexible way. It may be useful to refer to
[this feature test](https://github.com/truefootprint/field-backend/blob/master/spec/features/follow_up_activities_spec.rb)
since it's similar to this scenario.

[< back to README](https://github.com/truefootprint/field-backend#readme)
