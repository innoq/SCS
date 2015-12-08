---
layout: default
title: "SCS - Self-Contained Systems - SCS vs. Microservices"
---

SCS vs. Microservices
---

The SCS approach shares a lot of concepts with microservices, including ideas about
enforcing isolation via independently deployable units, the alignment
of organizational and architectural boundaries, support for diversity
in terms of technology choices, and the lack of centralized infrastructure. If
you're willing to see this as the core of microservices, you could view SCSs as 
a specialization. But compared to some other aspects seen by many people 
as key attributes of microservices, there are are some important differences:

<ul>
	<li id="smaller">A microservice is probably <a href="#smaller">smaller</a> than an SCS. An SCS might be
  large enough to keep a team busy and provide more meaningful
  business value.</li>

<li id="fewer">There are usually <a href="#fewer">fewer</a> SCSs than
  microservices. A logical system such as an e-commerce shop might have 5 to 25 SCSs
  i.e. for billing, order processing etc. An e-commerce shop might
  have 100s of microservices.</li>

<li id="no-communication">SCSs should ideally <a href="#no-communication">not communicate</a> with each other while this is
fine for microservices.

<li id="ui">SCSs have a <a href="#ui">UI</a>, while microservices might separate the UI from the
  logic in its own service. However, some definitions of microservices
  include the UI in the microservice, too.</li>

<li id="ui-integration"> SCSs should favor <a href="#ui-integration">integration at the UI layer</a>.
  Microservices typically focus on integration at the logic layer.
  (Again, some definitions of microservices also allow for integration at the UI layer.)
  </li>
  </ol>
  
Of course it is possible to split an SCS even further so it consists
of microservices — in particular for the business logic. In this case, this 
can be seen as a particular micro-architecture approach.

SCS clearly focus on larger projects and a split into multiple
teams. Microservices can be used for other purposes: Often small teams
or even single developers use them e.g. to use Continuous Delivery
more easy or to scale each Microservice independently.
