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
- **Direct LoadBalancer access** for CDN integration and custom domains
- **Single Gateway port (443)** handling both HTTP and gRPC protocols
- **TLS termination** at Gateway edge with automated certificate management
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
git clone https://github.com/coderbydesign/openshift-gateway-api-tutorial
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
│   ├── 04-echo-services-namespace.yaml  # Services namespace
│   ├── 05-http-echo-deployment.yaml     # HTTP echo service
│   ├── 06-grpc-echo-deployment.yaml     # gRPC echo service
│   ├── 07-httproute.yaml               # HTTP routing rules
│   ├── 08-grpcroute.yaml               # gRPC routing rules
│   ├── 09-authentication-policy.yaml   # JWT authentication
│   ├── 10-authorization-policy.yaml    # Global authorization
│   └── 11-http-route-authorization.yaml # Service-specific authorization
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
- Configure direct LoadBalancer access for external clients
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

## 🔗 Production Integration: Akamai CDN Setup

This tutorial's direct LoadBalancer architecture is designed for seamless CDN integration. Here's how to configure TLS and certificates for Akamai deployment:

### TLS Architecture with Akamai

```
Internet → [TLS 1] → Akamai → [TLS 2] → LoadBalancer → Gateway → Services
```

**Two certificate layers**:
1. **Public TLS (Internet → Akamai)**: Customer's domain certificate
2. **Origin TLS (Akamai → Gateway)**: Origin server certificate

### Certificate Configuration

#### 1. Public Certificate (Akamai Edge)

**Option A: Akamai Managed**
```bash
# Akamai automatically provisions Let's Encrypt certificates
# for your custom domain (api.yourcompany.com)
# No manual configuration needed
```

**Option B: Custom Certificate**
```bash
# Upload your own certificate to Akamai
# Supports EV certificates, wildcard certs, etc.
```

#### 2. Origin Certificate (Akamai → Gateway)

**Option A: Self-Signed (Recommended)**
```yaml
# Create self-signed issuer for origin certificates
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: origin-ca-issuer
  namespace: demo-gateway-poc
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: origin-certificate
  namespace: demo-gateway-poc
spec:
  secretName: origin-certificate
  issuerRef:
    name: origin-ca-issuer
  dnsNames:
  - "*.yourcompany.com"  # Wildcard for flexibility
  - "api.yourcompany.com"
  - "gateway.yourcompany.com"
```

**Option B: Internal CA**
```yaml
# Use your organization's internal CA
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: company-ca-issuer
spec:
  ca:
    secretName: company-ca-key-pair
```

**Option C: Public CA (Less Common)**
```yaml
# Use Let's Encrypt for origin (requires DNS validation)
# Note: HTTP-01 validation won't work behind Akamai
apiVersion: cert-manager.io/v1
kind: Certificate
spec:
  acme:
    solvers:
    - dns01:
        route53: # or other DNS provider
          region: us-east-1
          accessKeyID: AKIAI...
```

### Akamai Origin Configuration

#### Property Configuration
```json
{
  "origin": {
    "hostname": "a1b2c3d4-12345678.us-east-1.elb.amazonaws.com",
    "port": 443,
    "protocol": "HTTPS"
  },
  "forwardHostHeader": "INCOMING",  // Send custom domain in Host header
  "originCertVerification": "CUSTOM",
  "customCertificateAuthorities": ["...origin-ca-cert..."]
}
```

#### Host Header Forwarding
```javascript
// Akamai Edge Rule to forward correct Host header
if (request.url.startsWith("/api/")) {
  setOriginHeader("Host", "api.yourcompany.com");
}
```

### DNS Configuration

#### CNAME Setup
```dns
# Point your API domain to Akamai edge
api.yourcompany.com CNAME api.yourcompany.com.edgesuite.net

# Or direct to LoadBalancer for testing
test-gateway.yourcompany.com CNAME a1b2c3d4-12345678.us-east-1.elb.amazonaws.com
```

### Update Gateway Configuration

#### Update Certificate Reference
```yaml
# Update 01-gateway.yaml to use origin certificate
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: demo-e2w-gateway
spec:
  listeners:
  - name: https
    port: 443
    protocol: HTTPS
    tls:
      mode: Terminate
      certificateRefs:
      - name: origin-certificate  # Use origin cert instead of Let's Encrypt
```

#### Update Certificate Resource
```yaml
# Update 03-certificate.yaml for your domain
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: origin-certificate
spec:
  secretName: origin-certificate
  issuerRef:
    name: origin-ca-issuer  # Use origin issuer
  dnsNames:
  - "api.yourcompany.com"
  - "*.yourcompany.com"
```

### Testing Production Setup

#### 1. Test Origin Directly
```bash
# Test LoadBalancer with origin certificate
curl -k https://a1b2c3d4-12345678.us-east-1.elb.amazonaws.com/http \
  -H "Host: api.yourcompany.com"
```

#### 2. Test Through Akamai
```bash
# Test full CDN flow
curl https://api.yourcompany.com/http
```

#### 3. Validate Certificate Chain
```bash
# Check Akamai edge certificate
openssl s_client -connect api.yourcompany.com:443 -servername api.yourcompany.com

# Check origin certificate (from inside Akamai network)
openssl s_client -connect $LOADBALANCER_HOSTNAME:443 -servername api.yourcompany.com
```

### Security Considerations

#### Origin Protection
```yaml
# Restrict Gateway access to Akamai IP ranges only
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: akamai-only-access
spec:
  podSelector:
    matchLabels:
      app: gateway
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 23.0.0.0/8    # Akamai IP range example
    - ipBlock:
        cidr: 104.64.0.0/10 # Add all Akamai ranges
```

#### Certificate Rotation
```yaml
# Automate origin certificate renewal
apiVersion: cert-manager.io/v1
kind: Certificate
spec:
  renewBefore: 720h  # 30 days before expiry
  duration: 8760h    # 1 year validity
```

### Monitoring and Alerting

#### Certificate Expiry Monitoring
```yaml
# Example ServiceMonitor for cert-manager metrics
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: cert-manager-metrics
spec:
  selector:
    matchLabels:
      app: cert-manager
  endpoints:
  - port: tcp-prometheus-servicemonitor
```

#### Akamai Health Checks
```json
{
  "healthCheck": {
    "path": "/health",
    "protocol": "HTTPS",
    "port": 443,
    "interval": 30,
    "timeout": 10,
    "healthyThreshold": 2,
    "unhealthyThreshold": 3
  }
}
```

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