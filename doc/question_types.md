[< back to README](https://github.com/truefootprint/field-backend#readme)

## Question types

The primary purpose of the FieldApp is to ask questions of users and receive
responses. There are different types of question, both in terms of their
presentation and the type of data collected. This is reflected in the
[Question](https://github.com/truefootprint/field-backend/blob/master/app/models/question.rb)
model which has a `type` column and a `data_type` column.

There are three *types* of question:

- **FreeTextQuestion**: a question that is answered by typing in some text
- **MultiChoiceQuestion**: a question that is answered by selecting from a list of options
- **PhotoUploadQuestion**: a question that allows the user to take or select a photo

There are four *data types* for questions:

- **string**
- **boolean**
- **number**
- **photo**

These data types give meaning to the responses to questions. There is a
[DataTypeParser](https://github.com/truefootprint/field-backend/blob/master/app/services/data_type_parser.rb)
that converts a response's value to an appropriate type in Ruby. For example,
the value 'yes' is converted to `true` if the question's data type is boolean.

The `responses.value` column in the database therefore contains a mixture of
things that are stored in the lowest common denominator type which is `text`.
The system needs to treat each value appropriately based on its data type. For
example, response values for the 'photo' data type actually contain JSON.

Image uploads are explained in more detail [here](./image_uploads.md).

### Multi-choice

Multi-choice questions can use the `multiple_answers` flag on the questions
table to indicate that multiple answers may be provided, rather than just one.
The selected answers are stored in a single response value as an array.

This contains a list of IDs referencing MultiChoiceOptions which is where the
text content of the options is stored. We don't store this text directly in the
response because we might want to change it and this text can be translated into
other languages.

### Expected length

If the question is a FreeTextQuestion, the expected length column can be used to
indicate how many characters we expect to receive from the user. The FieldApp
can then present the question in a more suitable way, for example showing a
textarea instead of a textinput if the expected length is 100 characters.

### Examples

Here are some examples of questions with their data types:

- "How wide is the road?" (FreeTextQuestion, number)
- "Do you have any comments about the pump?" (FreeTextQuestion, string)
- "Did the construction worker show up?" (MultiChoiceQuestion, boolean)
- "Which healthcare items were missing?" (MultiChoiceQuestion, string)
- "Were you treated by one or two doctors?" (MultiChoiceQuestion, number)
- "Please take a photo of the workshop" (PhotoUploadQuestion, photo)

The last example isn't strictly a question, but we treat it as such. It's a
statement prompting the user for a response.

### Other things

Questions support a few other features, such as:

- Units: this is shown in the FieldApp next to the input field, e.g. 'metres'
- Completion questions: used to indicate this question completes the current activity
- Topics: used to organise questions into sections, e.g. 'Cement', 'Communication'

Additionally, questions can be set up once then created across multiple projects
with Templating. See the ["Templating"](https://github.com/truefootprint/field-backend/blob/master/doc/domain_model.md#templating) section of the Domain model for more information.

[< back to README](https://github.com/truefootprint/field-backend#readme)
