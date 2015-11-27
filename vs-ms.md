---
layout: default
title: "SCS - Self-Contained Systems - SCS vs. Microservices"
---

SCS vs. Microservices
---

At first sight, SCS seems to be very much like Microservices. However,
there are a some very important differences:

<ul>
	<li id="smaller">A Microservice is probably <a href="#smaller">smaller</a> than an SCS. An SCS might be
  large enough to keep a team busy and provide more meaningful
  business value.</li>

<li id="fewer">There are usually <a href="#fewer">fewer</a> SCS than
  Microservices. A logical system such as an e-commerce shop might have 5 to 25 SCS
  i.e. for billing, order processing etc. An e-commerce shop might
  have 100 of microservices.</li>

<li id="no-communication">SCS should ideally <a href="#no-communication">not communicate</a> with each other while this is
fine for Microservices.

<li id="ui">SCS have a <a href="#ui">UI</a> while Microservices might separate the UI from the
  logic in its own service. However, some definitions of Microservices
  include the UI in the Microservice, too.</li>

<li id="ui-integration"> SCS should be <a href="#ui-integration">integrated in the UI layer</a>. Microservices mostly
  focus on the integration in the logic layer. Again some definitions
  of Microservices also allow for integration in the UI layer.
  </li>
  </ol>
  
Of course it is possible to split an SCS even further so it consists
of Microservices — in particular for the business logic.
