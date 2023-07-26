---
layout: default
title: Why Self-contained Systems (SCS)?
description: Reasons to use the Self-contained Systems (SCS) software architecture
---

Why SCS?
---

There are many reasons why we think SCSs are appealing. This page gives
an overview of the most important ones.

### Disappointed by Monoliths

Monoliths are large applications that must be deployed as a whole. They
are hard to develop and maintain in the long run. The architecture
rots because it is too easy to introduce new dependencies — all it
takes is a developer who decides to use a class in a piece of code
where they really shouldn't. Also it takes long and it is complex to
test and deploy the monolith. Finally, if the monolith cannot be
maintained anymore it is essentially impossible to replace it. So we
need smaller, isolated deployment units that still fit a business purpose and
ideally also have an impact on the development organization.

### Local Decisions

A decision for a technology or architecture in one SCS is local to
that SCS. Changes for new requirements should be limited to one SCS as
it implements a functionality all by itself. Pretty much all decisions
concerning technology and many concerning architecture are local to a
single SCS. We have seen a lot of large monoliths fail. More
isolation on the architectural level promises to make even large
projects feasible.

### Isolation

An SCS is a natural unit in many regards. If one SCS fails, it will not
affect the other SCSs just because it is a separate process and does
not really interact with the other SCS. This makes high availability
easier. Also, from a security perspective, they are better isolated
against each other. If one SCS is compromised it does not necessarily
mean that the others are compromised, too.

### (Independent) Scaling

Each SCS can run on one or multiple servers to deal with high
load. Each SCS also manages its own data persistency, and ideally does not share
a central data persistence system with other SCSs. Also it should
communicate as little with other SCSs as possible and only
asynchronously. Thus, increased local
demand can be managed by scaling locally.

### Replaceability

Each SCS can be replaced. Quite a few projects try to replace legacy
systems. Those projects are usually quite complex and have a high
risk. Because each SCS can be replaced independently, a migration is
much easier.

### Playground Effect

It is much easier to try out new technologies and approaches. A
decision for a new technology can be limited to one SCS. So a
technology can be tried out with little risk but it will still run in
production. That avoids that the system will use outdated
technologies. Also, migrating to a new technology is easier.

### Integration with Legacy

A legacy system might be enhanced with some SCSs and slowly be
migrated — without touching a lot of the code. The default integration of SCSs
is through web UIs. It is often quite easy to integrate the SCSs with the legacy
system.

### Teams

An SCS is usually a good unit of software for a team to work on. It
provides a business functionality, so a team can work on stories for
just one SCS. That way SCSs can influence the organization of the
project — according to [Conway's Law](http://www.melconway.com/Home/Conways_Law.html).

### Experience

We have seen this architecture work in many projects. We believe it
solves some of the current challenges in software development. See
also the [links](/links.html) — quite a few people find the
approach helpful.
