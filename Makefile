all:
	gpp rst-api-spec.yaml.in > rst-api-spec.yaml
	gpp -DINTERNAL rst-api-spec.yaml.in > rst-api-spec-internal.yaml
