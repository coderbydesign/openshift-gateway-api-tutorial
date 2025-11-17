# OpenShift Service Mesh 3 Gateway API Tutorial

This repository contains an interactive, step-by-step tutorial for implementing an OpenShift Service Mesh 3 Gateway API solution with JWT authentication. The tutorial generates customized manifests based on your specific environment and requirements.

## 🎯 What You'll Build

By the end of this tutorial, you'll have a production-ready Gateway API implementation featuring:

- **Multi-protocol Gateway** supporting both HTTP and gRPC traffic
- **JWT Authentication** with configurable token issuers
- **Layered Authorization** with claims-based access control
- **TLS Termination** with automated certificate management
- **Cross-namespace Routing** with proper security isolation
- **Deny-by-default Security** with explicit allow policies

## 🏗️ Architecture Overview

For detailed architectural diagrams, traffic flow explanations, and design patterns, see **[ARCHITECTURE.md](ARCHITECTURE.md)**.

Key architectural highlights:
- **Single Gateway port (443)** handling both HTTP and gRPC protocols
- **TLS termination** at Gateway edge with Let's Encrypt certificates
- **JWT authentication** with configurable token issuers
- **Layered authorization** policies with claims-based validation
- **Cross-namespace routing** with proper security isolation

## 📋 Prerequisites

### Environment Requirements
- **OpenShift Cluster**: Version 4.19+ with cluster admin access
- **Service Mesh Operator**: Red Hat OpenShift Service Mesh 3 (v3.1.0+)
- **Gateway API**: CRDs installed and ready
- **cert-manager**: Installed for automatic TLS certificate management

### Verification Commands
```bash
# Check OpenShift version
oc version

# Verify Service Mesh operator
oc get csv -A | grep servicemesh

# Confirm Gateway API CRDs
oc get crd | grep gateway.networking.k8s.io

# Verify cluster admin access
oc auth can-i '*' '*'

# Check cert-manager installation
oc get pods -n cert-manager
```

### Knowledge Assumptions
- Basic understanding of Kubernetes and Gateway API concepts
- Familiarity with JWT tokens and claims-based authentication
- Experience with OpenShift or Kubernetes cluster administration
- General knowledge of service mesh concepts

## 🚀 Getting Started

### 1. Clone and Prepare Repository

```bash
git clone <repository-url>
cd openshift-gateway-api-tutorial

# Review the example implementation
ls -la example-generated/   # Example manifests with 'demo' prefix (shows tutorial output)
cat TUTORIAL-LOG.md         # Complete implementation chronicle
cat TEST-GUIDE.md           # Testing scenarios and examples
```

### 2. Start the Interactive Tutorial

**Option A: Use Claude Code CLI (Recommended)**

If you have [Claude Code](https://docs.claude.com/en/docs/claude-code) installed:

```bash
# Start Claude Code in this directory
claude
```

Then paste the tutorial initiation prompt from step 3 below.

**Option B: Use Claude via Web Interface**

Upload this repository to Claude and use the initiation prompt below.

### 3. Tutorial Initiation Prompt

Copy and paste this prompt into Claude to begin the interactive tutorial:

```
I want to work through the OpenShift Service Mesh 3 Gateway API tutorial in this repository using the openshift-mesh-instructor agent.

This repo contains example manifests and documentation for implementing a production-ready Gateway API solution with JWT authentication. I want you to use the specialized openshift-mesh-instructor agent to walk me through the tutorial step-by-step, customizing the implementation for my specific environment.

Please start by using the openshift-mesh-instructor agent to:
1. Read the CLAUDE.md file to understand the tutorial goals
2. Read the TUTORIAL-LOG.md to understand the complete implementation
3. Ask me for my specific configuration details (cluster domain, JWT issuer, naming prefix, etc.)
4. Generate customized manifests in a new 'generated/' directory based on my inputs
5. Walk me through each step interactively, waiting for my confirmation before proceeding

The agent should provide step-by-step guidance on implementing OpenShift Service Mesh 3 Gateway API solutions, particularly for cross-cluster communication, authentication policies, and service mesh configurations as described in this repository.

I'm ready to provide my environment details and begin the implementation!
```

## 🔧 Configuration Details You'll Provide

During the tutorial, Claude will ask you for these customization details:

### Basic Configuration
- **Project Prefix**: Replace 'demo' with your identifier (e.g., 'mycompany', 'team-alpha')
- **OpenShift Cluster Domain**: Your cluster's application domain
- **Namespace Strategy**: Single namespace vs. separate Gateway/services namespaces

### JWT Authentication Configuration
- **JWT Issuer**: Your JWT token issuer URL
- **JWKS URI**: Your JSON Web Key Set endpoint
- **Required Claims**: Specific claim names and expected values for authorization
- **Token Sources**: Header extraction patterns and optional query parameter support

### TLS Certificate Strategy
- **Certificate Authority**: Let's Encrypt (staging/prod) or custom CA
- **ClusterIssuer Configuration**: ACME challenge method preferences
- **Certificate Scope**: Single wildcard vs. specific hostname certificates

### Service Configuration
- **Backend Services**: HTTP and gRPC service implementations
- **Resource Limits**: CPU/memory constraints for your environment
- **Health Check Strategy**: Probe types and intervals

## 📁 Generated Output Structure

The tutorial will create a customized implementation in the `generated/` directory:

```
generated/
├── config.yaml                     # Your configuration inputs
├── manifests/
│   ├── 00-namespace.yaml          # Customized namespace(s)
│   ├── 01-gateway.yaml            # Gateway with your hostname
│   ├── 02-clusterissuer.yaml      # CA issuer configuration
│   ├── 03-certificate.yaml       # TLS certificate for your domain
│   ├── 04-route.yaml              # OpenShift Route configuration
│   ├── 05-echo-services-namespace.yaml  # Services namespace
│   ├── 06-http-echo-deployment.yaml     # HTTP echo service
│   ├── 07-grpc-echo-deployment.yaml     # gRPC echo service
│   ├── 08-httproute.yaml               # HTTP routing rules
│   ├── 09-grpcroute.yaml               # gRPC routing rules
│   ├── 11-authentication-policy.yaml   # JWT authentication
│   ├── 12-authorization-policy.yaml    # Global authorization
│   └── 13-http-route-authorization.yaml # Service-specific authorization
├── test-guide.md               # Customized testing instructions
├── cleanup.sh                  # Environment-specific cleanup script
└── deploy.sh                   # Automated deployment script
```

## 🎓 Tutorial Flow

The interactive tutorial follows this progression:

### Phase 1: Environment Discovery & Planning
- Verify your OpenShift cluster readiness
- Gather your specific configuration requirements
- Make architectural decisions for your use case
- Generate customized manifest files

### Phase 2: Infrastructure Deployment
- Create namespaces and basic Gateway resources
- Set up TLS certificate automation
- Configure external access via OpenShift Routes
- Verify basic Gateway functionality

### Phase 3: Service Implementation
- Deploy HTTP and gRPC echo services
- Create and attach routing rules
- Test protocol detection and routing
- Verify cross-namespace connectivity

### Phase 4: Authentication & Authorization
- Implement JWT authentication policies
- Configure claims-based authorization rules
- Test layered security policies
- Verify deny-by-default behavior

### Phase 5: Testing & Validation
- Run comprehensive test scenarios
- Validate authentication flows
- Test protocol-specific routing
- Verify security policy enforcement

## 📚 Reference Documentation

This repository includes comprehensive reference materials:

- **[ARCHITECTURE.md](ARCHITECTURE.md)**: Detailed architectural diagrams, traffic flows, and design patterns
- **[TUTORIAL-LOG.md](TUTORIAL-LOG.md)**: Complete implementation chronicle with troubleshooting details
- **[TEST-GUIDE.md](TEST-GUIDE.md)**: Comprehensive testing scenarios and examples
- **[example-generated/](example-generated/)**: Complete example implementation showing tutorial output
- **[cleanup.sh](cleanup.sh)**: Safe resource cleanup script

## 🔍 Example Use Cases

This tutorial supports various deployment scenarios:

### Enterprise Internal APIs
- JWT tokens from corporate SSO (Azure AD, Okta, etc.)
- Organization-specific claim validation
- Department or team-based authorization policies

### Red Hat Platform Services
- Integration with sso.redhat.com (pre-configured example)
- Red Hat-specific claim structures
- OpenShift cluster service account tokens

### Multi-tenant SaaS Platforms
- Customer-specific JWT issuers
- Tenant isolation via claim-based routing
- API versioning and canary deployments

### Development & Testing
- Local JWT issuer setup
- Simplified authentication for development
- Mock services for integration testing

## 🚨 Important Notes

### Security Considerations
- **Never commit real JWT tokens** to version control
- **Use staging certificates** for testing environments
- **Review authorization policies** carefully before production deployment
- **Monitor authentication failures** for security insights

### Production Readiness
- The tutorial generates **production-ready configurations**
- **Scale Gateway replicas** for high availability
- **Configure monitoring and alerting** for operational visibility
- **Implement GitOps workflows** for policy management

### Troubleshooting
- All tutorial steps include **verification commands**
- **Detailed logging guidance** for debugging authentication issues
- **Common error scenarios** with resolution steps
- **Reset procedures** if you need to start over

## 🤝 Contributing

This tutorial is designed to be:
- **Vendor-agnostic** while using OpenShift-specific features
- **Configurable** for different JWT issuers and claim structures
- **Educational** with detailed explanations of each architectural decision
- **Production-ready** with security and operational best practices

If you encounter issues or have suggestions for improvements, please refer to the troubleshooting sections in the generated documentation or the comprehensive implementation log.

---

**Ready to start?** Copy the tutorial initiation prompt above and begin your OpenShift Service Mesh 3 Gateway API journey! 🚀