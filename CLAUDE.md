Goal:
What I want you to do is output an interactive, step-by-step tutorial (asking/waiting on my input to move forward or clarify things) on creating a gateway api gateway + auth policy + routes + dummy service to test with. there's more context on the specifics below, but your output should be a markdown style tutorial workflow that we can go through step by step, only proceeding once I've verified things are working for a particular step, so that we can interactively troubleshoot as I go. this should be simple, straightforward, and a way to learn and prove out a poc. don't assume I know everything, but I do have some context. You're the professor/blog post author here so to speak, and I'm an engineer who's getting up to speed on the various technologies and will need resources and additional guidance to fully understand specifics. If there are any other details you'd prefer to know beforehand, ask/prompt me for them so you can better build this out.

Context:
The goal is to set up a cross-cluster gateway using the OpenShift Service Mesh 3 operator's Gateway API. This gateway will support first-party clients only, such as internal platform services and Red Hat-controlled workloads, to facilitate secure inter-cluster communication. The gateway will provide essential functionality for authentication, authorization, and observability to ensure a robust and controlled communication environment. The gateway will allow for both HTTP and GRPC endpoints to be exposed. The gateway will be easily extended to support additional token issuers.

Assume the following:
- basic knowledge/understanding of Kubernetes Gateway API
- history of working with NGINX/3scale for API gateways
- looking to move away from NGINX/3scale/bespoke gateways, in favor of service mesh/Gateway API
- will eventually have an e/w and n/s gateway, but this is focused on a simple e/w, cluster to cluster gateway
- clusters will be public
- already have a cluster up, on openshift 4.19, with service mesh/gateway api enabled already
- want to create a test Gateway, with an http and grpc route
- want to secure that with an auth policy
- want a dummy service behind the route(s)
- I have cluster admin access on our test cluster

Acceptance criteria for this poc:
- The gateway is set up using the OpenShift Service Mesh 3 operator.
- The gateway supports authentication with JWT tokens issued sso.redhat.com scheme (I can provide specifics here)
- The gateway can be easily configured to trust additional token issuers, such as OpenShift cluster service account tokens.
- The gateway implements edge-level authorization.
- The gateway is configured to deny all traffic by default, unless the client is explicitly allowed by an authorization policy.
- The gateway is capable of exposing both HTTP and GRPC endpoints.
- Use TLS from a tursted store that could use a default CA to auth with

Follow-ups/nice to haves if we get through everything else:
- The gateway is configured to produce logs that can be sent to CloudWatch.
- The gateway is configured to produce metrics in a Prometheus-compatible format.