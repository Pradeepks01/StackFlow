package kubernetes.admission

allow {
  input.request.kind.kind == "Pod"
  input.request.object.spec.securityContext.runAsNonRoot == true
}
