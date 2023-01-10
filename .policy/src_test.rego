package main

# originally from https://github.com/open-policy-agent/gatekeeper-library/blob/master/src/general/poddisruptionbudget/src_test.rego

namespace := "namespace-1"

namespace_eaas := "mercari-eaas-jp-dev"

match_labels := {"matchLabels": {
	"key1": "val1",
	"key2": "val2",
}}

test_input_pdb_0_max_unavailable {
	input := {"review": input_pdb_max_unavailable(0)}
	results := violation with input as input
	count(results) == 1
}

test_input_pdb_1_max_unavailable {
	input := {"review": input_pdb_max_unavailable(1)}
	results := violation with input as input
	count(results) == 0
}

test_input_deployment_1_replica_pdb_1_min_available {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_min_available(1)
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_deployment_1_replica_pdb_0p_min_available {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_min_available("0%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_1_replica_pdb_49p_min_available {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_min_available("49%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_1_replica_pdb_51p_min_available {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_min_available("51%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_deployment_1_replica_pdb_100p_min_available {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_min_available("100%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_deployment_2_replicas_pdb_1_min_available {
	input := {"review": input_deployment(2)}
	inv := inv_pdb_min_available(1)
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_pdb_0_max_unavailable {
	input := {"review": input_deployment(2)}
	inv := inv_pdb_max_unavailable(0)
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_deployment_pdb_1_max_unavailable {
	input := {"review": input_deployment(2)}
	inv := inv_pdb_max_unavailable(1)
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_1_pdb_0p_max_unavailable {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_max_unavailable("0%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_deployment_1_pdb_49p_max_unavailable {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_max_unavailable("49%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_deployment_1_pdb_51p_max_unavailable {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_max_unavailable("51%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_1_pdb_100p_max_unavailable {
	input := {"review": input_deployment(1)}
	inv := inv_pdb_max_unavailable("100%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_statefulset_1_replica_pdb_1_min_available {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_min_available(1)
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_statefulset_1_replica_pdb_0p_min_available {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_min_available("0%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_statefulset_1_replica_pdb_49p_min_available {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_min_available("49%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_statefulset_1_replica_pdb_51p_min_available {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_min_available("51%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_statefulset_1_replica_pdb_100p_min_available {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_min_available("100%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_statefulset_2_replicas_pdb_1_min_available {
	input := {"review": input_statefulset(2)}
	inv := inv_pdb_min_available(1)
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_statefulset_pdb_0_max_unavailable {
	input := {"review": input_statefulset(2)}
	inv := inv_pdb_max_unavailable(0)
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_statefulset_pdb_1_max_unavailable {
	input := {"review": input_statefulset(2)}
	inv := inv_pdb_max_unavailable(1)
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_statefulset_1_pdb_0p_max_unavailable {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_max_unavailable("0%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_statefulset_1_pdb_49p_max_unavailable {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_max_unavailable("49%")
	results := violation with input as input with data.inventory as inv
	count(results) == 1
}

test_input_statefulset_1_pdb_51p_max_unavailable {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_max_unavailable("51%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_statefulset_1_pdb_100p_max_unavailable {
	input := {"review": input_statefulset(1)}
	inv := inv_pdb_max_unavailable("100%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_eaas_1_replica_pdb_49p_min_available {
	input := {"review": input_deployment_eaas(1)}
	inv := inv_pdb_eaas_min_available("49%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_eaas_1_replica_pdb_51p_min_available {
	input := {"review": input_deployment_eaas(1)}
	inv := inv_pdb_eaas_min_available("51%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_eaas_1_pdb_0p_max_unavailable {
	input := {"review": input_deployment_eaas(1)}
	inv := inv_pdb_eaas_max_unavailable("0%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

test_input_deployment_1_pdb_49p_max_unavailable {
	input := {"review": input_deployment_eaas(1)}
	inv := inv_pdb_eaas_max_unavailable("49%")
	results := violation with input as input with data.inventory as inv
	count(results) == 0
}

pdb_min_available(min_available) = output {
	output := {
		"apiVersion": "policy/v1",
		"kind": "PodDisruptionBudget",
		"metadata": {
			"name": "pdb-1",
			"namespace": namespace,
		},
		"spec": {
			"selector": match_labels,
			"minAvailable": min_available,
		},
	}
}

pdb_eaas_min_available(min_available) = output {
	output := {
		"apiVersion": "policy/v1",
		"kind": "PodDisruptionBudget",
		"metadata": {
			"name": "pdb-1",
			"namespace": namespace_eaas,
		},
		"spec": {
			"selector": match_labels,
			"minAvailable": min_available,
		},
	}
}

pdb_max_unavailable(max_unavailable) = output {
	output := {
		"apiVersion": "policy/v1",
		"kind": "PodDisruptionBudget",
		"metadata": {
			"name": "pdb-1",
			"namespace": namespace,
		},
		"spec": {
			"selector": match_labels,
			"maxUnavailable": max_unavailable,
		},
	}
}

deployment(replicas) = output {
	output := {
		"apiVersion": "apps/v1",
		"kind": "Deployment",
		"metadata": {
			"name": "deployment-1",
			"namespace": namespace,
		},
		"spec": {
			"replicas": replicas,
			"selector": match_labels,
		},
	}
}

deployment_eaas(replicas) = output {
	output := {
		"apiVersion": "apps/v1",
		"kind": "Deployment",
		"metadata": {
			"name": "deployment-1",
			"namespace": namespace_eaas,
		},
		"spec": {
			"replicas": replicas,
			"selector": match_labels,
		},
	}
}

statefulset(replicas) = output {
	output := {
		"apiVersion": "apps/v1",
		"kind": "Statefulset",
		"metadata": {
			"name": "statefulset-1",
			"namespace": namespace,
		},
		"spec": {
			"replicas": replicas,
			"selector": match_labels,
		},
	}
}

input_pdb_max_unavailable(max_unavailable) = output {
	output := {
		"kind": {"kind": "PodDisruptionBudget"},
		"object": pdb_max_unavailable(max_unavailable),
	}
}

input_deployment(replicas) = output {
	output := {
		"kind": {"kind": "Deployment"},
		"object": deployment(replicas),
	}
}

input_deployment_eaas(replicas) = output {
	output := {
		"kind": {"kind": "Deployment"},
		"object": deployment_eaas(replicas),
	}
}

input_statefulset(replicas) = output {
	output := {
		"kind": {"kind": "Statefulset"},
		"object": statefulset(replicas),
	}
}

inventory(obj) = output {
	output := {"namespace": {namespace: {obj.apiVersion: {obj.kind: [obj]}}}}
}

inv_pdb_min_available(min_available) = output {
	pdb = pdb_min_available(min_available)
	output := inventory(pdb)
}

inv_pdb_eaas_min_available(min_available) = output {
	pdb = pdb_eaas_min_available(min_available)
	output := inventory(pdb)
}

inv_pdb_max_unavailable(max_unavailable) = output {
	pdb = pdb_max_unavailable(max_unavailable)
	output := inventory(pdb)
}

inv_pdb_eaas_max_unavailable(max_unavailable) = output {
	pdb = pdb_max_unavailable(max_unavailable)
	output := inventory(pdb)
}
