#!/bin/bash

# OpenShift Service Mesh 3 Gateway API POC - Cleanup Script
# Removes all resources created during the tutorial implementation

set -e

echo "🧹 Starting OpenShift Gateway API POC Cleanup..."
echo "=================================================="

# Function to safely delete resources
safe_delete() {
    local resource=$1
    local file=$2
    echo "🗑️  Deleting $resource from $file..."
    if oc delete -f "$file" --ignore-not-found=true; then
        echo "✅ Successfully deleted $resource"
    else
        echo "⚠️  Warning: Could not delete $resource (may not exist)"
    fi
    echo ""
}

# Function to check if file exists before deletion
delete_if_exists() {
    local file=$1
    local description=$2
    if [ -f "$file" ]; then
        safe_delete "$description" "$file"
    else
        echo "⏭️  Skipping $description - file $file not found"
        echo ""
    fi
}

echo "📋 Deleting resources in reverse order..."
echo ""

# Delete in reverse order of creation to handle dependencies properly
# Note: This script works with both generated/ and example-generated/ directories

MANIFEST_DIR="${1:-generated}"  # Default to generated/, allow override

echo "🎯 Using manifest directory: $MANIFEST_DIR"
echo ""

# Authentication and Authorization Policies
delete_if_exists "$MANIFEST_DIR/13-http-route-authorization.yaml" "HTTP-specific Authorization Policy"
delete_if_exists "$MANIFEST_DIR/12-authorization-policy.yaml" "Global Authorization Policy"
delete_if_exists "$MANIFEST_DIR/11-authentication-policy.yaml" "JWT Authentication Policy"

# Routes and Services
delete_if_exists "$MANIFEST_DIR/09-grpcroute.yaml" "gRPC Route"
delete_if_exists "$MANIFEST_DIR/08-httproute.yaml" "HTTP Route"
delete_if_exists "$MANIFEST_DIR/07-grpc-echo-deployment.yaml" "gRPC Echo Service"
delete_if_exists "$MANIFEST_DIR/06-http-echo-deployment.yaml" "HTTP Echo Service"
delete_if_exists "$MANIFEST_DIR/05-echo-services-namespace.yaml" "Echo Services Namespace"

# Gateway Infrastructure
delete_if_exists "$MANIFEST_DIR/04-route.yaml" "OpenShift Route"
delete_if_exists "$MANIFEST_DIR/03-certificate.yaml" "TLS Certificate"
delete_if_exists "$MANIFEST_DIR/01-gateway.yaml" "Gateway"
delete_if_exists "$MANIFEST_DIR/00-namespace.yaml" "Gateway Namespace"

# ClusterIssuer (cluster-scoped resource)
delete_if_exists "$MANIFEST_DIR/02-clusterissuer.yaml" "ClusterIssuer"

echo "🔍 Checking for remaining resources..."
echo "======================================"

# Verify namespace deletion
echo "📦 Checking namespaces..."
if oc get namespace demo-gateway-poc >/dev/null 2>&1; then
    echo "⚠️  Namespace 'demo-gateway-poc' still exists (may be terminating)"
else
    echo "✅ Namespace 'demo-gateway-poc' successfully deleted"
fi

if oc get namespace echo-services >/dev/null 2>&1; then
    echo "⚠️  Namespace 'echo-services' still exists (may be terminating)"
else
    echo "✅ Namespace 'echo-services' successfully deleted"
fi

# Check ClusterIssuer
echo "🔐 Checking ClusterIssuer..."
if oc get clusterissuer demo-gateway-poc-issuer >/dev/null 2>&1; then
    echo "⚠️  ClusterIssuer 'demo-gateway-poc-issuer' still exists"
else
    echo "✅ ClusterIssuer 'demo-gateway-poc-issuer' successfully deleted"
fi

# Check for any remaining Gateway resources
echo "🚪 Checking for remaining Gateway resources..."
REMAINING_GATEWAYS=$(oc get gateway --all-namespaces -o name 2>/dev/null | grep -c "demo" || true)
if [ "$REMAINING_GATEWAYS" -gt 0 ]; then
    echo "⚠️  Found $REMAINING_GATEWAYS remaining Gateway resources with 'demo' prefix"
    oc get gateway --all-namespaces | grep demo || true
else
    echo "✅ No remaining Gateway resources found"
fi

echo ""
echo "🎯 Cleanup Summary"
echo "=================="
echo "📁 Manifest files preserved for future use"
echo "🧹 All Kubernetes resources removed"
echo "📚 Documentation (TUTORIAL-LOG.md, TEST-GUIDE.md) preserved"
echo ""

# Optional: Show what files remain
echo "📋 Remaining files in project:"
echo "=============================="
ls -la *.md *.sh example-generated/ generated/ 2>/dev/null || echo "No manifest directories found"

echo ""
echo "✨ Cleanup complete! Ready for fresh deployment."
echo ""
echo "💡 To redeploy, run:"
echo "   # For generated manifests:"
echo "   for f in generated/*.yaml; do oc apply -f \"\$f\"; done"
echo ""
echo "   # For example manifests:"
echo "   for f in example-generated/*.yaml; do oc apply -f \"\$f\"; done"
echo ""