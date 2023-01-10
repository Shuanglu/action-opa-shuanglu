package main

########
# Documentation: https://microservices.mercari.in/references/kubernetes-resource-policies/service/
# Changes to this policy *MUST* be reflected by documentation.
########

# Use manifest to hold input data
# for a common interface between both
# conftest and gatekeeper

# originally from https://github.com/open-policy-agent/gatekeeper-library/blob/master/src/general/poddisruptionbudget/src.rego

violation[{"msg": msg}] {
	input.review.kind.kind == "PodDisruptionBudget"
	pdb := input.review.object
	not in_whitelist(pdb.metadata.namespace)
	is_number(pdb.spec.maxUnavailable)
	not valid_pdb_max_unavailable(pdb)
	msg := sprintf(
		"PodDisruptionBudget <%v> has maxUnavailable of 0, only positive integers are allowed for maxUnavailable",
		[pdb.metadata.name],
	)
}

violation[{"msg": msg}] {
	obj := input.review.object
	pdb := data.inventory.namespace[obj.metadata.namespace]["policy/v1"].PodDisruptionBudget[_]
	obj.spec.selector.matchLabels == pdb.spec.selector.matchLabels
	not in_whitelist(obj.metadata.namespace)
	is_number(pdb.spec.maxUnavailable)
	not valid_pdb_max_unavailable(pdb)
	msg := sprintf(
		"%v <%v> has been selected by PodDisruptionBudget <%v> but has maxUnavailable of 0, only positive integers are allowed for maxUnavailable",
		[obj.kind, obj.metadata.name, pdb.metadata.name],
	)
}

violation[{"msg": msg}] {
	obj := input.review.object
	pdb := data.inventory.namespace[obj.metadata.namespace]["policy/v1"].PodDisruptionBudget[_]
	obj.spec.selector.matchLabels == pdb.spec.selector.matchLabels
	not in_whitelist(obj.metadata.namespace)
	not is_number(pdb.spec.maxUnavailable)
	not valid_pdb_max_unavailable_percentage(obj, pdb)
	msg := sprintf(
		"%v <%v> has been selected by PodDisruptionBudget <%v> but has multiplication of replicas and maxUnavailable is 0, only positive integers are allowed for maxUnavailable",
		[obj.kind, obj.metadata.name, pdb.metadata.name],
	)
}

violation[{"msg": msg}] {
	obj := input.review.object
	pdb := data.inventory.namespace[obj.metadata.namespace]["policy/v1"].PodDisruptionBudget[_]
	obj.spec.selector.matchLabels == pdb.spec.selector.matchLabels
	not in_whitelist(obj.metadata.namespace)
	is_number(pdb.spec.minAvailable)
	not valid_pdb_min_available(obj, pdb)
	msg := sprintf(
		"%v <%v> has %v replica(s) but PodDisruptionBudget <%v> has minAvailable of %v, PodDisruptionBudget count should always be lower than replica(s), and not used when replica(s) is set to 1",
		[obj.kind, obj.metadata.name, obj.spec.replicas, pdb.metadata.name, pdb.spec.minAvailable, obj.spec.replicas],
	)
}

violation[{"msg": msg}] {
	obj := input.review.object
	pdb := data.inventory.namespace[obj.metadata.namespace]["policy/v1"].PodDisruptionBudget[_]
	obj.spec.selector.matchLabels == pdb.spec.selector.matchLabels
	not in_whitelist(obj.metadata.namespace)
	not is_number(pdb.spec.minAvailable)
	not valid_pdb_min_available_percentage(obj, pdb)
	msg := sprintf(
		"%v <%v> has %v replica(s) but PodDisruptionBudget <%v> has the multiplication result of pdb.spec.minAvailable %v * obj.spec.replicas %v, PodDisruptionBudget count should always be lower than replica(s), and not used when replica(s) is set to 1",
		[obj.kind, obj.metadata.name, obj.spec.replicas, pdb.metadata.name, pdb.spec.minAvailable, obj.spec.replicas],
	)
}

valid_pdb_min_available(obj, pdb) {
	# default to -1 if minAvailable is not set so valid_pdb_min_available is always true
	# for objects with >= 0 replicas. If minAvailable defaults to >= 0, objects with
	# replicas field might violate this constraint if they are equal to the default set here
	min_available := object.get(pdb.spec, "minAvailable", -1)
	obj.spec.replicas > min_available
}

valid_pdb_min_available_percentage(obj, pdb) {
	# add the calculation for percentage scenario https://kubernetes.io/docs/tasks/run-application/configure-pdb/#rounding-logic-when-specifying-percentages
	min_available := object.get(pdb.spec, "minAvailable", -1)
	min_available_multiplication := round((to_number(split(min_available, "%")[0]) / 100) * object.get(obj.spec, "replicas", 0))
	obj.spec.replicas > min_available_multiplication
}

valid_pdb_max_unavailable(pdb) {
	# default to 1 if maxUnavailable is not set so valid_pdb_max_unavailable always returns true.
	# If maxUnavailable defaults to 0, it violates this constraint because all pods needs to be
	# available and no pods can be evicted voluntarily
	max_unavailable := object.get(pdb.spec, "maxUnavailable", 1)
	max_unavailable > 0
}

valid_pdb_max_unavailable_percentage(obj, pdb) {
	# 	# add the calculation for percentage scenario https://kubernetes.io/docs/tasks/run-application/configure-pdb/#rounding-logic-when-specifying-percentages
	max_unavailable := object.get(pdb.spec, "maxUnavailable", 1)
	max_unavailable_multiplication := round((to_number(split(max_unavailable, "%")[0]) / 100) * object.get(obj.spec, "replicas", 0))
	max_unavailable_multiplication > 0
}

in_whitelist(namespace) {
	whitelist := ["^mercari-eaas-jp-"]
	whitelist_match_results := {x |
		re_match(whitelist[_], namespace)
		x := true
	}
	count(whitelist_match_results) > 0
}
