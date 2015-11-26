---
layout: default
title: "SCS - Self-Contained Systems - FAQ"
---

Frequently Asked Questions
---

### Why the term "SCS"?

"Self-Contained System" describes best what’s at the core of the
concept: Each system should work by itself. Together they form a
"System of Systems".

### Does SCS intend to replace other concepts?

No. SCS can be combined with Microservices for example — see
[SCS vs. Microservices](/vs-ms.html).

### How do I know which systems to build?

Each SCS is responsible for a part of the domain. Dividing the domain
into bounded contexts and understanding their relationships is what
we refer to as *Domain Architecture*. Ideally, there is one SCS per
bounded context.

### SCS are very isolated — how can they still form one system?

The goal of SCS is to localize decisions. However, to make a system of
SCS work together some decisions affect all SCS. We can therefore
distinguish:

* Local decisions in one SCS are called *Micro Architecture*. This
  includes almost all technical decisions e.g. the programming
  language or the frameworks.

* Decisions that can only be made on the global level are called
  *Macro Architecture*. Actually, only very few things fall into this
  category: The protocol SCS can use to communicate with each other
  and the UI integration. Also a way to do data replication or the
  platform might be part of the Macro Architecture.

Of course it is still possible to decide parts of the
Micro Architecture on the global level. I.e. you can either decide
that all SCS must use Java (decision on the global level) or each SCS
can use a different programming language (decision for each
SCS). However, if you want to port your system of SCSs to a new
platform it might make sense to later allow each SCS to use a
different programming language i.e. change the global decision to a
local one.

### Each SCS has its own ideas and technology. Isn't that bound to end in chaos?

See above — you can limit the decisions each SCS can make by defining
common decisions for all SCSs. Note, however, that this spoils the idea of
independent decisions. You need to find some compromise. Defining a
common technology for all SCS might not be a bad idea e.g. it makes
refactoring across SCS easier and developers can work on more than one
SCS at the same time. But of course it limits the decisions each team can make.

### What about Mobile Clients or Single Page Apps (SPA)?

SCS focus on Web UIs that are split across the SCSs. However, each SCS
might also provide an API that can be accessed by mobile clients or a
single page app. However, the functionalities are then split across
the SCS containing the logic and the mobile clients or single page app
containing the UI. That way a change cannot be confined to an SCS but
would affect the SCS as well as the mobile clients and the single page
app. This problem can be mitigated by modularizing the mobile client or the
SPA so that changes to the UI are simplified. Even then the mobile
client or SPA remains a deployment unit by itself i.e. besides the SCS
also the mobile client / SPA must be redeployed and deployment of the
client / SPA must be coordinated with the deployment of the
SCS. Essentially, this approach violates
[no shared UI](/index.html#no-shared-ui).

We believe [ROCA](http://roca-style.org) is a good approach for web
front ends for SCS because that approach makes it easy to combine UIs
from several SCSs to one. You could also have one SPA per SCS — but
that means changing from one SCS/SPA to another one loads another
application and you cannot easily share parts of the SPA/SCS in other
SPA/SCS.

### May SCS share a database?

Multiple SCS might use the same database - but they must not share any
data. So they might have completely separate schemas in the same
physical database. Sharing a schema is not allowed - it means the
schema can hardly be changed. The changes would need to be coordinated
between all components that use the data and introduces a strong
coupling that SCS should avoid.

Even using separate schemas in the same database causes some coupling
e.g. an update to the database software would influence all
SCSs. However, all SCS can use the same backup and disaster recovery
and thereby save ressources.

### How can I use this document?

This document is licensed under a Creative Commons license,
i.e. you can essentially use it as you see fit, as long as you
include proper attribution and share your modifications under
the same license. We explicitly encourage you to recommend,
compare or develop frameworks according to this style, and
intend to be as open as reasonably possible while maintaining
conceptual integrity. You can find the source at
[GitHub](https://github.com/innoq/SCS) .

### Can I provide feedback?

Of course, please use [the comments](discussion.html) to
share your thoughts. We welcome criticism as well as suggestions for
improvement.
