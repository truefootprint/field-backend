[< back to README](https://github.com/truefootprint/field-backend#readme)

## Project history

The project began in the summer of 2019 and was developed by
[Chris Patuzzo](https://github.com/tuzz) and
[Edwin Bos](https://github.com/edwin-truefootprint) out of the
[Go Free Range](https://gofreerange.com/) offices with occasional design and UX
help from Carly Denham.

Collectively, the FieldApp,
its backend and the admin system were referred to as the 'Reporter'. The idea
was that people in local communities would 'report' on the progress of projects
in their area. A few months later it was renamed to the 'FieldApp' after a
product branding session.  The names 'FieldBackend' and 'FieldAdmin' are
internal names only.

We initially created some throwaway projects that were used for demo'ing
purposes and to explore the problem space. Some of these were to iterate on the
user-interface/design of the app, while others were to understand more about
its domain model. Some of these projects are still running on GitHub pages if
you want to take a look.

## Throwaway projects

**Reporter demo**

- [GitHub repository](https://github.com/truefootprint/reporter-demo)
- [GitHub pages](https://reporter-demo.truefootprint.com/)

A Next.js web app that was used in demos. It emulates the look of a mobile
device and asks some questions about example projects. You can select
photos/videos but none of the data is persisted. On the last screen you can
click the TrueFootprint logo to be presented with a dropdown to select a
different project or language.

---

**Reporter frontend**

- [GitHub repository](https://github.com/truefootprint/reporter-frontend)

A Next.js web app that was a very early version of a a live application that can
speak to a backend to present a list of questions. It allowed the user to answer
questions and it explored the idea that each project has a 'current
activity'. This can be advanced by the user answering 'Yes, this activity is now
finished'. This concept was later incorporated into the FieldApp.

---

**Reporter design prototype**

- [GitHub repository](https://github.com/truefootprint/reporter-design-prototype)
- [GitHub pages](https://reporter-design-prototype.truefootprint.com/)

A Next.js web app that implemented the first version of the design from Carly.
The main idea was to have 'cards' that can be swiped left and right be the user.
These cards would contains questions about the project they are monitoring. You
can use the left and right arrow keys to play an animation that approximates
swiping left and right.

This design was tested by a few people and we concluded the left and right
swiping was too confusing.

---

**Reporter design prototype 2**

- [GitHub repository](https://github.com/truefootprint/reporter-design-prototype-2)
- [GitHub pages](https://reporter-design-prototype-2.truefootprint.com/garden_path)

A Next.js web app that stacked cards in a vertical list rather than side by
side. If you're viewing this in a desktop browser, you need to reduce its width
to the size of a mobile device.

---

**Reporter mobile app**

- [GitHub repository](https://github.com/truefootprint/reporter-mobile-app)

A React Native app created to try building the 'sticky headers' design concept
into a native Android app. The learnings from this prototype were later
incorporated into the FieldApp. After this, development on the FieldApp began.


[< back to README](https://github.com/truefootprint/field-backend#readme)
