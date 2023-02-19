# QuickAction

![00000](https://user-images.githubusercontent.com/54146662/219953018-5f1eef03-468b-4432-8741-c9b90b9078e2.png)

## Inspiration
Our team was largely inspired by the tragic events of the MSU active shooting incident. This event brought to light how our current systems to handle these devastating events can often lead to misinformation, distrust, and inefficiency.

Additionally, our team found that these disastrous events can disproportionately affect people with disabilities. Because of this, our team proposes a new system that makes indoor localization (and evacuation) much more accessible when sight is limited. 

## What it does
One of the main features of Quick Action is the ability to localize the user in a room, and create a custom AR map to the nearest exit of the building. This system was designed to be extremely assesible to all users, especially the vision impared. **Our app guides the user through the environment through detailed spoken instructions and visual cues based on the users current position**. 

Our team also **implemented a fully-integrated person-counting system for lockdown situations**. In this system, users are able to report specific locations that they are currently sheltering in place in which can be used as extra information by law enforcement. Users are able to "panic" which signals the 911 dispatcher that they are in distress. Additionally, **a backend was fully implemented that allows the 911 dispatcher to sort and signal groups of people with important rescue information**.

## How we built it
Our team has always dreamed of creating a full-stack Augmented Reality application. However, to make that dream come true over the past 36 hours, our team members have been having significantly fewer dreams than usual.

Our project uses Apple's ARKit and Google Firebase extensively. Our team members specialized in what was most interesting to them (no necessarily what they knew the most about) and tackled the project piece by piece.

## Challenges we ran into
There were plenty of challenges that our team faced during this project. Our team typically found that when integrating our changes together, small issues would present themselves that would consume a large amount of time (merge conflicts, tricky bugs, etc). On a few occasions, we got to play detective. trying to figure out what specific event caused a bug to be exposed in our code. This process was very enlightening and fun! (more so when you find the solution.)

Our team found a significant challenge in adapting to the ARKit framework that we did not have much experience in. The documentation for the software was decent, however, the amount of examples that our team could find online made it more of a challenge. 

## Accomplishments that we're proud of
One of our biggest accomplishments in this project is the focus and **success of our product for assessability in indoor navigation**. Through extensive testing and development, our team honed in on a ARKit solution with incredibly high fidelity and accuracy at navigating users through indoor environments by visual cues and speech guidance. This component of making technology more accessible for everyone (especially in evacuation/disaster situations) is one that is largely overlooked and we believe that technology can be leveraged in this area to make people's lives easier. 

Another accomplishment that we are really proud of is **our method of transferring important data from the users (through reports) to the 911 dispatch operators**. Through the use of Firebase, our team was able to login, make requests, store user information, and instantly integrate that data into a live dashboard that the dispatcher can take advantage of. This systematic and reliable process gives us hope that a system like ours can be used to prevent some level of danger in future disastrous scenarios.

## What we learned
Our team had no shortage of interesting frameworks to learn or problems to tackle. In fact, some of our members were introduced into IOS development for the first time this weekend! Additionally, our team made strides in git version control, and a plethora of new frameworks needed to create a full-stack application.

## What's next for Quick Action
Although we have accomplished a lot in 36 we are certainly not short of ideas to implement for future developments.

Here are some ideas we have:

<u>More robust evacuation plans:</u> enabling the app to be used for different types of emergencies, such as fires, earthquakes, or active shooter situations.

<u>Hazard reporting:</u> The app can allow users to report hazards or other safety concerns in real-time, which can help to alert emergency responders and other users to potential risks.

<u>Including more accessibility features:</u> Everything from have multilingual support to making it accessible for others with disabilities.

<u>Making indor tracking more robust:</u> although vision has seved us well with this application having access to wifi based positing migh help in situations where vision fails.

<u>Privacy and security features:</u> The app can include strong privacy and security features to protect user data and ensure that sensitive information is only accessible to authorized personnel.

The business plan moving forward
Our vision is to empower and provide safety to individuals with vision impairments and the wider community during emergency situations such as fires or shooter threats. Our team is passionate about the potential of this app to make a significant positive impact on society thereby we will move forward as a sustainable non-profit organization. we are committed to ensuring that our emergency navigation and notification app is accessible and affordable for everyone.

To achieve this goal, we plan to explore various funding opportunities, including grants and donations from government agencies, private foundations, and individual donors who share our mission of providing safety and inclusivity for all. Additionally, we will seek out corporate sponsorships to help us reduce backend costs and maximize the impact of our app, and we believe that with the right funding and support, we can bring it to life. Together, we can create a safer and more inclusive community, where everyone feels empowered to navigate emergency situations with confidence and ease.
