# OpenShift Service Mesh 3 Gateway API - Testing Guide

This guide provides comprehensive test scenarios for validating the Gateway API implementation with JWT authentication.

## Environment Setup

**Gateway Endpoint**: `https://demo-gateway-poc.apps.your-cluster.example.com`

**Authentication**: JWT tokens from `sso.redhat.com` with required claims:
- `iss`: `https://sso.redhat.com/auth/realms/redhat-external`
- `scope`: Must contain `"api.console"`
- `org_id`: Must equal `"12345"` (HTTP routes only)

## Test Scenarios

### 1. Unauthenticated Requests (Should Fail)

**HTTP Test - No JWT**:
```bash
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/http
```
**Expected Result**: `403 RBAC: access denied`

**gRPC Test - No JWT**:
```bash
grpcurl -insecure demo-gateway-poc.apps.your-cluster.example.com:443 list
```
**Expected Result**: `rpc error: code = PermissionDenied desc = RBAC: access denied`

### 2. Invalid JWT Tokens (Should Fail)

**HTTP Test - Invalid JWT**:
```bash
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/http \
  -H 'Authorization: Bearer invalid.jwt.token'
```
**Expected Result**: `403 Jwt is not in the form of Header.Payload.Signature`

**gRPC Test - Invalid JWT**:
```bash
grpcurl -H 'Authorization: Bearer invalid.jwt.token' \
  -insecure demo-gateway-poc.apps.your-cluster.example.com:443 list
```
**Expected Result**: `rpc error: code = PermissionDenied desc = Jwt is not in the form of Header.Payload.Signature`

### 3. Valid JWT Missing Required Claims (Should Fail)

**HTTP Test - Missing scope claim**:
```bash
# JWT without "api.console" in scope claim
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/http \
  -H 'Authorization: Bearer <jwt_without_scope>'
```
**Expected Result**: `403 RBAC: access denied`

**HTTP Test - Missing org_id claim**:
```bash
# JWT with correct scope but missing org_id="12345"
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/http \
  -H 'Authorization: Bearer <jwt_without_org_id>'
```
**Expected Result**: `403 RBAC: access denied`

**gRPC Test - Missing scope claim**:
```bash
# JWT without "api.console" in scope claim
grpcurl -H 'Authorization: Bearer <jwt_without_scope>' \
  -insecure demo-gateway-poc.apps.your-cluster.example.com:443 list
```
**Expected Result**: `rpc error: code = PermissionDenied desc = RBAC: access denied`

### 4. Valid JWT with Required Claims (Should Succeed)

**HTTP Test - Complete valid JWT**:
```bash
# JWT with scope="api.console" AND org_id="12345"
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/http \
  -H 'Authorization: Bearer <valid_jwt_with_all_claims>'
```
**Expected Result**: `200 OK` with response: `"Hello from HTTP Echo Service via Gateway API!"`

**gRPC Test - Valid JWT with scope only**:
```bash
# JWT with scope="api.console" (org_id not required for gRPC)
grpcurl -H 'Authorization: Bearer <valid_jwt_with_scope>' \
  -insecure demo-gateway-poc.apps.your-cluster.example.com:443 list
```
**Expected Result**: Connection success (may show "server does not support the reflection API" - this is expected from busybox)

### 5. Protocol-Specific Routing Verification

**HTTP/1.1 Path Routing**:
```bash
# Verify HTTPRoute path matching
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/http \
  -H 'Authorization: Bearer <valid_jwt>'

# Non-matching path should fail
curl -v https://demo-gateway-poc.apps.your-cluster.example.com/notfound \
  -H 'Authorization: Bearer <valid_jwt>'
```
**Expected Results**:
- `/http` path: Success with echo response
- `/notfound` path: `404 Not Found`

**gRPC Protocol Detection**:
```bash
# Verify GRPCRoute protocol handling
grpcurl -H 'Authorization: Bearer <valid_jwt>' \
  -insecure demo-gateway-poc.apps.your-cluster.example.com:443 \
  echo.EchoService/Echo
```
**Expected Result**: Connection to gRPC service (busybox TCP server)

## Troubleshooting Commands

### Gateway Status Check
```bash
oc get gateway demo-e2w-gateway -n demo-gateway-poc -o yaml
```

### Authentication Policy Status
```bash
oc get requestauthentication -n demo-gateway-poc
oc get authorizationpolicy -n demo-gateway-poc
oc get authorizationpolicy -n echo-services
```

### Service Connectivity
```bash
# Test internal service connectivity
oc exec -n echo-services deployment/http-echo -- curl localhost:8080
oc exec -n echo-services deployment/grpc-echo -- nc -z localhost 50051
```

### Gateway Logs
```bash
# Check Gateway pod logs for authentication failures
oc logs -n demo-gateway-poc -l gateway.networking.k8s.io/gateway-name=demo-e2w-gateway
```

### Istio Proxy Logs
```bash
# Check Envoy access logs for detailed request tracing
oc logs -n demo-gateway-poc -l gateway.networking.k8s.io/gateway-name=demo-e2w-gateway -c istio-proxy
```

## Testing Workflow

1. **Start with unauthenticated tests** to verify deny-by-default behavior
2. **Test invalid JWTs** to verify token validation
3. **Test missing claims** to verify authorization policies
4. **Test valid tokens** to verify successful authentication flow
5. **Verify protocol-specific routing** works correctly
6. **Check logs** if any tests fail unexpectedly

## Expected Test Results Summary

| Test Scenario | HTTP Endpoint | gRPC Endpoint | Expected Status |
|---------------|---------------|---------------|-----------------|
| No JWT | ❌ 403 RBAC | ❌ Permission Denied | FAIL (Expected) |
| Invalid JWT | ❌ 403 Invalid | ❌ Permission Denied | FAIL (Expected) |
| Missing scope | ❌ 403 RBAC | ❌ Permission Denied | FAIL (Expected) |
| Missing org_id | ❌ 403 RBAC | ✅ Connection | HTTP FAIL / gRPC PASS (Expected) |
| Valid JWT + Claims | ✅ 200 OK | ✅ Connection | PASS (Expected) |

This testing approach validates the complete authentication and authorization flow for your OpenShift Service Mesh 3 Gateway API implementation.