---
layout: default
title: "SCS - Self-Contained Systems - SCS vs. Microservices"
---

SCS vs. Microservices
---

At first sight, SCS seems to be very much like Microservices. However,
there are a some very important differences:

* A Microservice is probably smaller than an SCS. An SCS might be
  large enough to keep a team busy and provide more meaningful
  business value.

* A logical system such as an e-commerce shop might have 5 to 25 SCS
  i.e. for billing, order processing etc. An e-commerce shop might
  have 100 of microservices.

* SCS should ideally not communicate with each other while this is
fine for Microservices.

* SCS have a UI while Microservices might separate the UI from the
  logic in its own service. However, some definitions of Microservices
  include the UI in the Microservice, too.

* SCS should be integrated in the UI layer. Microservices mostly
  focus on the integration in the logic layer. Again some definitions
  of Microservices also allow for integration in the UI layer.

Of course it is possible to split an SCS even further so it consists
of Microservices — in particular for the business logic.
